/**
 * What a readiness report says about a service.
 *
 * Three states rather than two, because a service whose cache is unreachable
 * should keep serving whilst a service whose schema is half-applied should
 * not. Collapsing them means either taking a working service out of rotation
 * or leaving a broken one in it.
 */
export const HealthStatus = {
  /** Every dependency answered as expected. */
  Ready: "ready",
  /** Something is wrong that the service can serve around. */
  Degraded: "degraded",
  /** Something the service cannot work without is unavailable or inconsistent. */
  Failed: "failed",
} as const;

/** One of the states in {@link HealthStatus}. */
export type HealthStatus = (typeof HealthStatus)[keyof typeof HealthStatus];

/** What one check reports about the thing it proves. */
export interface HealthProbe {
  /** What the check found. */
  status: HealthStatus;
  /**
   * A short safe sentence for the report body.
   *
   * It is read by whoever is looking at a failing deployment, so it says what
   * is wrong rather than restating the status. It carries no credential, no
   * connection string and no query text, because the readiness endpoint is
   * reachable from inside the project and its body ends up in screenshots.
   */
  detail?: string;
}

/** A named thing a service proves before it accepts traffic. */
export interface HealthCheck {
  /**
   * What is being proved, as a dotted path such as `database.migrations`.
   *
   * It appears in the report and in the log line, so it names the dependency
   * and the property rather than the function that tests it.
   */
  name: string;
  /**
   * Whether the service can serve without this.
   *
   * A critical check failing takes the container out of rotation. A
   * non-critical one failing leaves it serving and says so.
   */
  critical: boolean;
  /** Proves the thing, or throws. A throw is treated as a failure. */
  run(): Promise<HealthProbe>;
}

/** What one check reported, with what it cost. */
export interface HealthCheckResult extends HealthProbe {
  /** The check's name. */
  name: string;
  /** Whether the service can serve without it. */
  critical: boolean;
  /** How long the check took, in milliseconds. */
  durationMs: number;
}

/** What the readiness endpoint answers with. */
export interface HealthReport {
  /** The aggregate state. */
  status: HealthStatus;
  /** When the report was produced, as an ISO 8601 instant. */
  checkedAt: string;
  /** How long every check took together, in milliseconds. */
  durationMs: number;
  /** One entry per check, in the order the checks were given. */
  checks: HealthCheckResult[];
}

/** How a readiness run is bounded and timed. */
export interface HealthRunOptions {
  /** How long one check may take before it counts as failed. */
  timeoutMs?: number;
  /** The clock, injected so a test does not depend on the real one. */
  now?: () => Date;
  /** A monotonic millisecond reading, injected for the same reason. */
  elapsed?: () => number;
}

/**
 * Raised when a service asks for a readiness report it cannot produce.
 *
 * This is a programming error rather than an operational one, so it is a
 * distinct type: it must fail the service's own start-up rather than be
 * reported as a failing dependency.
 */
export class HealthCheckConfigurationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "HealthCheckConfigurationError";
  }
}

/** The default bound on one check. */
const defaultTimeoutMs = 2_000;

/** The safe detail used when a check throws or never answers. */
const opaqueFailureDetail = "The check did not complete. The reason is in the service log under this check's name.";

/**
 * Runs every readiness check and aggregates what they found.
 *
 * A readiness endpoint exists to keep a container that cannot serve correctly
 * out of rotation. A check set that proves nothing is therefore the same as
 * having no endpoint at all, which is why an empty set is rejected rather than
 * reported as ready.
 *
 * Checks run together rather than one after another, because readiness is
 * asked for on a schedule and a slow dependency should not delay the answer
 * about the others.
 *
 * @param checks - The dependencies to prove. Must not be empty.
 * @param options - Clock and timeout, injected for tests.
 * @returns What every check found and the aggregate state.
 * @throws {HealthCheckConfigurationError} When no check is given, or two
 *   checks share a name and the report could not be read unambiguously.
 */
export async function runHealthChecks(
  checks: readonly HealthCheck[],
  options: HealthRunOptions = {},
): Promise<HealthReport> {
  if (checks.length === 0) {
    throw new HealthCheckConfigurationError(
      "A readiness report needs at least one check. An endpoint that proves nothing reports that the process is listening, which the network already establishes.",
    );
  }

  const duplicate = firstDuplicateName(checks);
  if (duplicate !== undefined) {
    throw new HealthCheckConfigurationError(`Two readiness checks are both named "${duplicate}".`);
  }

  const now = options.now ?? (() => new Date());
  const elapsed = options.elapsed ?? (() => performance.now());
  const timeoutMs = options.timeoutMs ?? defaultTimeoutMs;

  const startedAt = elapsed();
  const results = await Promise.all(checks.map((check) => runOne(check, timeoutMs, elapsed)));

  return {
    status: aggregate(results),
    checkedAt: now().toISOString(),
    durationMs: Math.round(elapsed() - startedAt),
    checks: results,
  };
}

/**
 * The HTTP status a readiness report answers with.
 *
 * Degraded answers 200 on purpose. The platform takes a container out of
 * rotation on a failing check, and a service that can still serve most
 * requests is worse off removed than left in place. The report body is what
 * says something is wrong.
 *
 * @param report - The report being answered with.
 * @returns 503 when the service cannot serve, 200 otherwise.
 */
export function httpStatusForHealthReport(report: HealthReport): 200 | 503 {
  return report.status === HealthStatus.Failed ? 503 : 200;
}

/**
 * Runs one check, bounding how long it may take and catching what it throws.
 *
 * A check that throws reports a fixed safe sentence rather than the thrown
 * message, because a driver puts its connection string into that message. The
 * real cause belongs in the log, where redaction has already been applied.
 */
async function runOne(check: HealthCheck, timeoutMs: number, elapsed: () => number): Promise<HealthCheckResult> {
  const startedAt = elapsed();

  const probe = await Promise.race([
    check.run().catch(() => failedProbe()),
    timeout(timeoutMs).then(() => failedProbe()),
  ]);

  return {
    name: check.name,
    critical: check.critical,
    status: probe.status,
    ...(probe.detail === undefined ? {} : { detail: probe.detail }),
    durationMs: Math.round(elapsed() - startedAt),
  };
}

/** The probe reported when a check throws or never answers. */
function failedProbe(): HealthProbe {
  return { status: HealthStatus.Failed, detail: opaqueFailureDetail };
}

/** Resolves after the given delay. */
function timeout(milliseconds: number): Promise<void> {
  return new Promise((resolve) => {
    const handle = setTimeout(resolve, milliseconds);
    // Nothing should be held alive by a readiness timeout, so the timer does
    // not keep the process running once the other side of the race has won.
    handle.unref?.();
  });
}

/** Reduces the individual results to one state. */
function aggregate(results: readonly HealthCheckResult[]): HealthStatus {
  if (results.some((result) => result.critical && result.status === HealthStatus.Failed)) {
    return HealthStatus.Failed;
  }

  if (results.some((result) => result.status !== HealthStatus.Ready)) {
    return HealthStatus.Degraded;
  }

  return HealthStatus.Ready;
}

/** The first name claimed by two checks, or `undefined`. */
function firstDuplicateName(checks: readonly HealthCheck[]): string | undefined {
  const seen = new Set<string>();

  for (const check of checks) {
    if (seen.has(check.name)) return check.name;
    seen.add(check.name);
  }

  return undefined;
}
