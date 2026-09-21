/**
 * The operational facts the private runbook is rendered from.
 *
 * The runbook itself is written to `Documentations/private/` and never
 * committed. A repository is cloned, backed up, mirrored by tooling and can
 * change visibility in either direction, so anything committed to it is
 * committed to every copy of it permanently, whatever the current setting
 * says. An incident procedure naming real identifiers does not belong in one.
 *
 * What lives here is only the mechanics, every one of which Zerops already
 * publishes, so the knowledge survives a fresh checkout whilst the identifiers
 * do not.
 *
 * Anything an operator has to fill in locally is a {@link RunbookPlaceholder}
 * rather than a value, so the difference between what is known and what has to
 * be looked up is visible in the rendered document.
 */

/** A value an operator fills in on their own machine. */
export interface RunbookPlaceholder {
  /** What has to be filled in. */
  label: string;
  /** Where to find it. */
  source: string;
}

/** One step of a procedure. */
export interface RunbookStep {
  /** What to do, as an instruction. */
  action: string;
  /** Why, where the reason is not obvious from the action. */
  reason?: string;
}

/** A named procedure with its steps. */
export interface RunbookProcedure {
  /** What the procedure is for. */
  title: string;
  /** When to reach for it. */
  when: string;
  /** The steps, in order. */
  steps: readonly RunbookStep[];
  /**
   * Something the operator should know that is not a step.
   *
   * Used where a published route could not be confirmed against the tools
   * actually installed. Writing an unverified command into a runbook is worse
   * than leaving it out, because it is read during an incident by somebody
   * with no time to discover it does not exist.
   */
  note?: string;
}

/**
 * How Zerops backs up the database, as Zerops documents it.
 *
 * None of this is set in `zerops-project-import.yml`. Zerops has no key for
 * it, so the schedule and retention are applied in the project's interface at
 * provisioning, and these are the values to apply. Recording them here is what
 * makes the intended setting reviewable rather than something only the console
 * knows.
 *
 * @see https://docs.zerops.io/features/backup
 */
export const backupPolicy = {
  /** What Zerops backs up without being asked. */
  automatic: "Every service that stores data, which for Playable means the PostgreSQL service.",
  /** When the automatic backup runs. */
  schedule: "Daily, between 00:00 and 01:00 UTC.",
  /** How long Zerops keeps them by default. */
  retention: "At least 7 daily, 4 weekly and 3 monthly backups, up to 50 per service.",
  /** Where the intended values are applied, since no file carries them. */
  configuredIn: "The Zerops project interface. The import definition has no key for backup settings.",
  /** What has to happen before a deployment that could need undoing. */
  beforeRiskyDeployment:
    "Take a tagged backup first, so the restore point is the state immediately before the change rather than up to a day earlier.",
} as const;

/** The identifiers an operator supplies that this repository must not hold. */
export const runbookPlaceholders: readonly RunbookPlaceholder[] = [
  { label: "Zerops project ID", source: "The project overview in the Zerops interface." },
  { label: "Production database service ID", source: "The database service page in the Zerops interface." },
  { label: "Incident contact", source: "Whoever is on call. For now that is the repository owner." },
];

/** Taking a backup on purpose, rather than waiting for the nightly one. */
export const manualBackupProcedure: RunbookProcedure = {
  title: "Take a backup before a risky change",
  when: "Before any deployment that migrates the schema, backfills data, or changes ownership.",
  steps: [
    {
      action: "Take a manual backup of the database service from the Zerops interface and give it a protected tag.",
      reason:
        "The protected tag keeps it out of the automatic deletion that trims the oldest backups once the limit is reached.",
    },
    {
      action: "Confirm the backup appears in the project's backup list before deploying.",
      reason: "A backup that was requested is not the same as a backup that exists.",
    },
  ],
  note: "Zerops' documentation describes a `zcli backup create` command. zcli 1.1.0 does not provide one, under any command group, so the interface is the route that has actually been confirmed. Check again after upgrading the CLI.",
};

/** Proving the backups are worth having. */
export const restoreDrillProcedure: RunbookProcedure = {
  title: "Restore drill",
  when: "Once after the project is first provisioned, and once after any change to the schema tooling.",
  steps: [
    {
      action: "Download the most recent daily backup from the project's backup list.",
    },
    {
      action: "Restore it into a scratch database that is not the production one.",
      reason:
        "A drill that restores over the live database turns a rehearsal into the incident it was meant to prepare for.",
    },
    {
      action: "Check the restored database against what the application expects.",
      reason:
        "A restore that produces a readable file proves the file. Checking the expected tables, the runtime role's grants and the applied migration state proves the backup.",
    },
    {
      action: "Record the date of the drill and delete the scratch database.",
      reason: "A scratch database left behind is indistinguishable from a real one a month later.",
    },
  ],
  note: "The check in step three is the readiness verification built in #20. Until that exists and the project is provisioned, this drill has never been run, and a backup nobody has restored is a hope rather than a recovery plan.",
};

/** Undoing a deployment that made things worse. */
export const rollbackProcedure: RunbookProcedure = {
  title: "Roll back a deployment",
  when: "When a deployment is serving errors, or its readiness check does not clear.",
  steps: [
    {
      action: "Read the readiness report of the failing service before changing anything.",
      reason:
        "It names which dependency is unsatisfied, which decides whether this is a rollback at all or a database that has not finished starting.",
    },
    {
      action: "Activate the previous deployment of the affected service in the Zerops interface.",
      reason: "The previous build is kept, so a rollback is a switch rather than a rebuild.",
    },
    {
      action: "Decide separately whether the schema needs reverting.",
      reason:
        "Rolling the code back does not roll the schema back. An additive migration is safe to leave; one that dropped or rewrote something needs the backup taken before the deployment.",
    },
    {
      action: "Confirm the readiness check clears and the error rate falls before closing the incident.",
    },
  ],
};

/** What to do while something is on fire. */
export const incidentProcedure: RunbookProcedure = {
  title: "Handle an incident",
  when: "When a service is failing, degraded, or answering wrongly.",
  steps: [
    {
      action: "Read the readiness report of each service and write down which checks are failing.",
      reason: "It distinguishes a service that is broken from one waiting on a dependency that is.",
    },
    {
      action:
        "Find the error ID from the report or from what the person reporting it quoted, and search the logs for it.",
      reason: "The error ID is what connects a report to the one line explaining it. A timestamp is a guess.",
    },
    {
      action: "Decide between rolling back and fixing forward, and say which in the incident note.",
      reason:
        "Both are defensible and doing neither whilst deciding is not. A rollback is fast and loses the fix; a fix forward is slower and needs the same gates as any change.",
    },
    {
      action: "Once it is over, write down what failed, what was done, and what would have caught it earlier.",
      reason: "The last part is the only one that changes anything, and it is the one skipped when it is late.",
    },
  ],
};

/** Every procedure, in the order the runbook presents them. */
export const runbookProcedures: readonly RunbookProcedure[] = [
  incidentProcedure,
  rollbackProcedure,
  manualBackupProcedure,
  restoreDrillProcedure,
];
