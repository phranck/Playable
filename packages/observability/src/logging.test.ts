import { PlayableService } from "@playable/contracts";
import { beforeEach, describe, expect, it } from "vitest";
import { createLogger, FailureKind, LogLevel, type LogRecord, Outcome } from "./logging.js";
import { REDACTED } from "./redaction.js";

let written: LogRecord[];

/** A logger whose clock, writer and identifier source are all predictable. */
function logger() {
  return createLogger({
    service: PlayableService.Backend,
    write: (record) => written.push(record),
    now: () => new Date("2026-09-21T10:00:00.000Z"),
    generateErrorId: () => "error-1",
  });
}

beforeEach(() => {
  written = [];
});

describe("info", () => {
  it("records the service, the time and a successful outcome", () => {
    logger().info("Served the live catalog", { operation: "GET /live", requestId: "request-1", status: 200 });

    expect(written[0]).toMatchObject({
      timestamp: "2026-09-21T10:00:00.000Z",
      level: LogLevel.Info,
      service: PlayableService.Backend,
      message: "Served the live catalog",
      operation: "GET /live",
      requestId: "request-1",
      status: 200,
      outcome: Outcome.Succeeded,
    });
  });

  it("leaves out what the caller did not supply", () => {
    logger().info("Started");

    expect(written[0]).not.toHaveProperty("requestId");
    expect(written[0]).not.toHaveProperty("status");
  });
});

describe("failure", () => {
  it("carries a code, an identifier and the category", () => {
    const errorId = logger().failure("Could not read the live catalog", {
      operation: "GET /live",
      errorCode: "live_catalog_unavailable",
      failureKind: FailureKind.Infrastructure,
    });

    expect(errorId).toBe("error-1");
    expect(written[0]).toMatchObject({
      errorCode: "live_catalog_unavailable",
      errorId: "error-1",
      failureKind: FailureKind.Infrastructure,
      outcome: Outcome.Failed,
    });
  });

  it("redacts the cause", () => {
    logger().failure("Could not reach the database", {
      errorCode: "database_unreachable",
      failureKind: FailureKind.Infrastructure,
      cause: new Error("connect ECONNREFUSED postgresql://playable:hunter2@db:5432/playable"),
    });

    expect(JSON.stringify(written[0])).not.toContain("hunter2");
  });

  it("redacts context supplied by the caller", () => {
    logger().failure("Rejected the request", {
      errorCode: "invalid_body",
      failureKind: FailureKind.UserInput,
      context: { authorization: "Bearer abcdef0123456789", field: "podcastId" },
    });

    expect(written[0]?.context).toEqual({ authorization: REDACTED, field: "podcastId" });
  });

  it("writes a rejected request at warn and an unreachable dependency at error", () => {
    const log = logger();

    log.failure("Rejected the request", { errorCode: "invalid_body", failureKind: FailureKind.UserInput });
    log.failure("Database unreachable", { errorCode: "db_down", failureKind: FailureKind.Infrastructure });
    log.failure("Unreachable branch", { errorCode: "invariant", failureKind: FailureKind.Programming });

    expect(written.map((record) => record.level)).toEqual([LogLevel.Warn, LogLevel.Error, LogLevel.Error]);
  });
});

describe("deviation", () => {
  it("records a fallback outcome with what was done instead", () => {
    const errorId = logger().deviation("Live catalog came from the cache", {
      operation: "GET /live",
      errorCode: "live_catalog_stale",
      failureKind: FailureKind.Infrastructure,
      fallback: "Served the last known catalog.",
    });

    expect(errorId).toBe("error-1");
    expect(written[0]).toMatchObject({
      outcome: Outcome.Fallback,
      errorCode: "live_catalog_stale",
      errorId: "error-1",
    });
    expect(written[0]?.context).toMatchObject({ fallback: "Served the last known catalog." });
  });

  it("keeps the caller's context beside the fallback", () => {
    logger().deviation("Live catalog came from the cache", {
      errorCode: "live_catalog_stale",
      failureKind: FailureKind.Infrastructure,
      fallback: "Served the last known catalog.",
      context: { ageSeconds: 42 },
    });

    expect(written[0]?.context).toEqual({ ageSeconds: 42, fallback: "Served the last known catalog." });
  });

  it("redacts the cause of a deviation too", () => {
    logger().deviation("Live catalog came from the cache", {
      errorCode: "live_catalog_stale",
      failureKind: FailureKind.Infrastructure,
      fallback: "Served the last known catalog.",
      cause: { DATABASE_URL: "postgresql://a:b@c/d" },
    });

    expect(written[0]?.cause).toEqual({ DATABASE_URL: REDACTED });
  });
});
