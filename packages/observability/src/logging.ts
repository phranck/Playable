import type { PlayableServiceName } from "@playable/contracts";
import { redact } from "./redaction.js";

/** How loud a log record is. */
export const LogLevel = {
  Debug: "debug",
  Info: "info",
  Warn: "warn",
  Error: "error",
} as const;

/** One of the levels in {@link LogLevel}. */
export type LogLevel = (typeof LogLevel)[keyof typeof LogLevel];

/**
 * What kind of thing went wrong.
 *
 * A rejected request body and an unreachable database are both failures and
 * nothing alike. The first is the system working, arrives constantly, and
 * would bury the second if both were logged the same way.
 */
export const FailureKind = {
  /** The caller sent something the contract does not allow. */
  UserInput: "user_input",
  /** A dependency was unavailable, slow or inconsistent. */
  Infrastructure: "infrastructure",
  /** The code did something it should not be able to do. */
  Programming: "programming",
} as const;

/** One of the kinds in {@link FailureKind}. */
export type FailureKind = (typeof FailureKind)[keyof typeof FailureKind];

/** What happened in the end. */
export const Outcome = {
  /** The operation did what it was asked. */
  Succeeded: "succeeded",
  /** Something went wrong and a fallback produced an acceptable answer. */
  Fallback: "fallback",
  /** The operation did not produce an answer. */
  Failed: "failed",
} as const;

/** One of the outcomes in {@link Outcome}. */
export type Outcome = (typeof Outcome)[keyof typeof Outcome];

/** One line in the log. */
export interface LogRecord {
  /** When it happened, as an ISO 8601 instant. */
  timestamp: string;
  /** How loud it is. */
  level: LogLevel;
  /** Which service wrote it. */
  service: PlayableServiceName;
  /** What happened, in one safe sentence. */
  message: string;
  /** The route or job this belongs to, such as `GET /live` or `job.refresh-feeds`. */
  operation?: string;
  /** The identifier carried through one request, so its lines can be gathered. */
  requestId?: string;
  /** The HTTP status, when there is one. */
  status?: number;
  /** What happened in the end. */
  outcome?: Outcome;
  /** The stable machine-readable reason. */
  errorCode?: string;
  /** The identifier a person can quote to find this line. */
  errorId?: string;
  /** Which category of failure this is. */
  failureKind?: FailureKind;
  /** The underlying cause, redacted. */
  cause?: unknown;
  /** Anything else worth recording, redacted. */
  context?: Record<string, unknown>;
}

/** What a caller says about a successful operation. */
export interface OperationDetails {
  /** The route or job. */
  operation?: string;
  /** The request this belongs to. */
  requestId?: string;
  /** The HTTP status, when there is one. */
  status?: number;
  /** Anything else worth recording. It is redacted before it is written. */
  context?: Record<string, unknown>;
}

/** What a caller says about a failure. */
export interface FailureDetails extends OperationDetails {
  /** The stable machine-readable reason. Every failure path has its own. */
  errorCode: string;
  /** Which category this is, so the noisy one cannot bury the serious one. */
  failureKind: FailureKind;
  /** What actually went wrong. It is redacted before it is written. */
  cause?: unknown;
}

/** What a caller says about a deviation a fallback absorbed. */
export interface DeviationDetails extends FailureDetails {
  /** What the service did instead, in one safe sentence. */
  fallback: string;
}

/** How a logger is built. */
export interface LoggerOptions {
  /** The service writing the records. */
  service: PlayableServiceName;
  /** Where a finished record goes. Defaults to one JSON line on standard output. */
  write?: (record: LogRecord) => void;
  /** The clock, injected so a test does not depend on the real one. */
  now?: () => Date;
  /** Produces the identifier a person quotes. Injected for the same reason. */
  generateErrorId?: () => string;
}

/** What a service writes its log through. */
export interface Logger {
  /** Records something that happened, with no failure involved. */
  info(message: string, details?: OperationDetails): void;
  /**
   * Records a deviation that a fallback absorbed.
   *
   * Handling something successfully and logging nothing is how a fallback that
   * fires constantly comes to look exactly like a system that never fails.
   *
   * @returns The error ID written, so the caller can quote it.
   */
  deviation(message: string, details: DeviationDetails): string;
  /**
   * Records a failure that produced no answer.
   *
   * @returns The error ID written, so the boundary can hand it to the caller.
   */
  failure(message: string, details: FailureDetails): string;
}

/**
 * Builds the logger a service writes every record through.
 *
 * Redaction happens here rather than at the call sites, because a call site
 * that forgets it leaks a credential permanently into whatever log store
 * received the line.
 *
 * @param options - The service, and the clock, writer and identifier source
 *   that tests replace.
 * @returns A logger bound to that service.
 */
export function createLogger(options: LoggerOptions): Logger {
  const { service } = options;
  const now = options.now ?? (() => new Date());
  const write = options.write ?? writeJsonLine;
  const generateErrorId = options.generateErrorId ?? defaultErrorId;

  /** Builds the fields every record carries. */
  function base(level: LogLevel, message: string, details: OperationDetails): LogRecord {
    return {
      timestamp: now().toISOString(),
      level,
      service,
      message,
      ...optional("operation", details.operation),
      ...optional("requestId", details.requestId),
      ...optional("status", details.status),
      ...(details.context === undefined ? {} : { context: redact(details.context) as Record<string, unknown> }),
    };
  }

  return {
    info(message, details = {}) {
      write({ ...base(LogLevel.Info, message, details), outcome: Outcome.Succeeded });
    },

    deviation(message, details) {
      const errorId = generateErrorId();
      const record = base(levelFor(details.failureKind), message, details);

      write({
        ...record,
        outcome: Outcome.Fallback,
        errorCode: details.errorCode,
        errorId,
        failureKind: details.failureKind,
        // What the service did instead belongs beside the reason it had to,
        // so one line answers both questions.
        context: { ...record.context, fallback: details.fallback },
        ...(details.cause === undefined ? {} : { cause: redact(details.cause) }),
      });

      return errorId;
    },

    failure(message, details) {
      const errorId = generateErrorId();

      write({
        ...base(levelFor(details.failureKind), message, details),
        outcome: Outcome.Failed,
        errorCode: details.errorCode,
        errorId,
        failureKind: details.failureKind,
        ...(details.cause === undefined ? {} : { cause: redact(details.cause) }),
      });

      return errorId;
    },
  };
}

/**
 * The level a failure of this kind is written at.
 *
 * A rejected request body is the system working as designed and arrives
 * constantly, so it is a warning. Everything else means somebody has to look.
 *
 * @param kind - The category of failure.
 * @returns The level to write it at.
 */
export function levelFor(kind: FailureKind): LogLevel {
  return kind === FailureKind.UserInput ? LogLevel.Warn : LogLevel.Error;
}

/**
 * The identifier a person quotes when they report that something broke.
 *
 * It is what connects "it broke at about four" to the one line that explains
 * it. Without one, diagnosis starts from a timestamp and a guess.
 */
function defaultErrorId(): string {
  return crypto.randomUUID();
}

/** Writes one record as a single JSON line on standard output. */
function writeJsonLine(record: LogRecord): void {
  process.stdout.write(`${JSON.stringify(record)}\n`);
}

/** Includes a field only when it has a value, so records stay free of nulls. */
function optional<Key extends string, Value>(key: Key, value: Value | undefined): Partial<Record<Key, Value>> {
  return value === undefined ? {} : ({ [key]: value } as Record<Key, Value>);
}
