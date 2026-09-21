import { describe, expect, it } from "vitest";
import {
  type HealthCheck,
  HealthCheckConfigurationError,
  HealthStatus,
  httpStatusForHealthReport,
  runHealthChecks,
} from "./health.js";

/**
 * Builds a check that reports what it is told.
 *
 * @param name - The check's name.
 * @param status - What it should report.
 * @param critical - Whether the service can serve without it.
 */
function check(name: string, status: HealthStatus, critical = true): HealthCheck {
  return { name, critical, run: async () => ({ status }) };
}

/** A clock and stopwatch that do not depend on the real ones. */
const fixedClock = { now: () => new Date("2026-09-21T10:00:00.000Z"), elapsed: () => 0 };

describe("runHealthChecks", () => {
  it("reports ready when every check is ready", async () => {
    const report = await runHealthChecks([check("database.reachable", HealthStatus.Ready)], fixedClock);

    expect(report.status).toBe(HealthStatus.Ready);
    expect(report.checkedAt).toBe("2026-09-21T10:00:00.000Z");
    expect(report.checks).toHaveLength(1);
  });

  it("refuses a report with nothing to prove", async () => {
    await expect(runHealthChecks([], fixedClock)).rejects.toBeInstanceOf(HealthCheckConfigurationError);
  });

  it("refuses two checks that share a name", async () => {
    const checks = [check("database.reachable", HealthStatus.Ready), check("database.reachable", HealthStatus.Ready)];

    await expect(runHealthChecks(checks, fixedClock)).rejects.toBeInstanceOf(HealthCheckConfigurationError);
  });

  it("fails when a critical check fails", async () => {
    const report = await runHealthChecks(
      [check("database.migrations", HealthStatus.Failed), check("cache.reachable", HealthStatus.Ready, false)],
      fixedClock,
    );

    expect(report.status).toBe(HealthStatus.Failed);
  });

  it("degrades rather than fails when a non-critical check fails", async () => {
    const report = await runHealthChecks(
      [check("database.migrations", HealthStatus.Ready), check("cache.reachable", HealthStatus.Failed, false)],
      fixedClock,
    );

    expect(report.status).toBe(HealthStatus.Degraded);
  });

  it("degrades when a check reports degraded", async () => {
    const report = await runHealthChecks([check("database.replication", HealthStatus.Degraded)], fixedClock);

    expect(report.status).toBe(HealthStatus.Degraded);
  });

  it("treats a check that throws as failed, without repeating what it threw", async () => {
    const thrower: HealthCheck = {
      name: "database.reachable",
      critical: true,
      run: async () => {
        throw new Error("could not connect to postgresql://playable:hunter2@db:5432/playable");
      },
    };

    const report = await runHealthChecks([thrower], fixedClock);

    expect(report.status).toBe(HealthStatus.Failed);
    expect(report.checks[0]?.detail).not.toContain("hunter2");
    expect(report.checks[0]?.detail).toContain("service log");
  });

  it("treats a check that never answers as failed", async () => {
    const hanging: HealthCheck = {
      name: "database.reachable",
      critical: true,
      run: () => new Promise(() => {}),
    };

    const report = await runHealthChecks([hanging], { ...fixedClock, timeoutMs: 10 });

    expect(report.status).toBe(HealthStatus.Failed);
  });

  it("keeps the checks in the order they were given", async () => {
    const report = await runHealthChecks(
      [
        check("database.reachable", HealthStatus.Ready),
        check("database.migrations", HealthStatus.Ready),
        check("cache.reachable", HealthStatus.Ready, false),
      ],
      fixedClock,
    );

    expect(report.checks.map((result) => result.name)).toEqual([
      "database.reachable",
      "database.migrations",
      "cache.reachable",
    ]);
  });
});

describe("httpStatusForHealthReport", () => {
  it("answers 503 only when the service cannot serve", async () => {
    const failed = await runHealthChecks([check("database.migrations", HealthStatus.Failed)], fixedClock);

    expect(httpStatusForHealthReport(failed)).toBe(503);
  });

  it("keeps a degraded service in rotation", async () => {
    const degraded = await runHealthChecks([check("cache.reachable", HealthStatus.Failed, false)], fixedClock);

    expect(degraded.status).toBe(HealthStatus.Degraded);
    expect(httpStatusForHealthReport(degraded)).toBe(200);
  });
});
