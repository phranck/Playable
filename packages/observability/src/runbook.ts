import { backupPolicy, runbookPlaceholders, runbookProcedures } from "./operations.js";

/**
 * Renders the private operations runbook.
 *
 * The document goes to `Documentations/private/`, which never leaves the
 * machine. It is rendered rather than written by hand so the procedures
 * survive a fresh checkout without the identifiers they need being committed
 * to a repository at all.
 *
 * @returns The complete Markdown document, ending in a newline.
 */
export function renderOperationsRunbook(): string {
  const lines = [
    "<!--",
    "Generated from packages/observability/src/operations.ts.",
    "Editing this file has no effect: the next run overwrites it.",
    "Change that file and run pnpm generate.",
    "-->",
    "",
    "# Operations runbook",
    "",
    "This document stays on this machine. The procedures below are versioned in the repository; the identifiers they need are not. A repository is cloned, backed up and can change visibility, so anything committed to it is committed to every copy of it permanently.",
    "",
    "## What to fill in",
    "",
    "| Value | Where to find it |",
    "|---|---|",
    ...runbookPlaceholders.map((placeholder) => `| ${placeholder.label} | ${placeholder.source} |`),
    "",
    "## Backups",
    "",
    `Zerops backs up automatically. ${backupPolicy.automatic}`,
    "",
    `- **Schedule:** ${backupPolicy.schedule}`,
    `- **Retention:** ${backupPolicy.retention}`,
    `- **Configured in:** ${backupPolicy.configuredIn}`,
    `- **Before a risky deployment:** ${backupPolicy.beforeRiskyDeployment}`,
    "",
  ];

  for (const procedure of runbookProcedures) {
    lines.push(`## ${procedure.title}`, "", `**When.** ${procedure.when}`, "");
    if (procedure.note) lines.push(`**Note.** ${procedure.note}`, "");

    procedure.steps.forEach((step, index) => {
      lines.push(`${index + 1}. ${step.action}`);
      if (step.reason) lines.push(`   ${step.reason}`);
      lines.push("");
    });
  }

  return lines.join("\n");
}
