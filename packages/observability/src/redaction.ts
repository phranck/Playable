import { administrativeDatabaseUrlName, configurationInventory } from "@playable/config";

/** What replaces a value that must not be written to a log. */
export const REDACTED = "[redacted]";

/**
 * Field names whose value is never written to a log, whatever it holds.
 *
 * The secrets Playable configures come from the configuration inventory, so a
 * variable marked secret there is redacted here without a second edit. The
 * literals beside them are names that arrive from elsewhere: a request header,
 * a database driver's error object, a third-party client's options.
 *
 * Matching is case-insensitive and on substrings, because the same value
 * travels under `authorization`, `Authorization` and `authorizationHeader`.
 */
const secretFieldNames: readonly string[] = [
  ...configurationInventory.filter((entry) => entry.secret).map((entry) => entry.name),
  administrativeDatabaseUrlName,
  "password",
  "passwd",
  "secret",
  "token",
  "authorization",
  "cookie",
  "apikey",
  "api_key",
  "credential",
  "connectionstring",
  "privatekey",
];

/**
 * Values that are a credential whatever field they arrive in.
 *
 * A driver that fails to connect puts the whole connection string into its
 * error message, where no field name marks it. That message is the single most
 * likely way a password reaches a log, so the value itself is matched too.
 */
const secretValuePatterns: readonly RegExp[] = [
  // A URL carrying credentials, such as postgresql://user:password@host/db.
  /\b[a-z][a-z0-9+.-]*:\/\/[^\s/@]+:[^\s/@]+@/i,
  // An Authorization header value.
  /\b(bearer|basic)\s+[\w\-._~+/=]{8,}/i,
  // A JSON Web Token.
  /\beyJ[\w-]{6,}\.[\w-]{6,}\.[\w-]{6,}/,
];

/**
 * How deep redaction walks before it stops.
 *
 * An error object can hold a reference back to a client holding its own
 * configuration, so an unbounded walk both takes a long time and reaches
 * further than anything a log line needs.
 */
const maximumDepth = 6;

/**
 * Removes credentials from anything about to be written to a log.
 *
 * Redaction is applied at the point of logging rather than trusted to callers,
 * because the first leak is already permanent in whatever log store received
 * it. There is no way to unsee a password in a shared log viewer.
 *
 * @param value - Any value, typically a caught error or a context object.
 * @returns A structure of the same shape with every credential replaced by
 *   {@link REDACTED}. The input is never modified.
 */
export function redact(value: unknown): unknown {
  return redactAtDepth(value, 0, new WeakSet());
}

/**
 * Reports whether a field name marks its value as a credential.
 *
 * @param name - The field or variable name.
 * @returns `true` when the value under that name must not be logged.
 */
export function isSecretFieldName(name: string): boolean {
  const normalized = name.toLowerCase().replaceAll(/[^a-z0-9]/g, "");
  return secretFieldNames.some((secret) => normalized.includes(secret.toLowerCase().replaceAll(/[^a-z0-9]/g, "")));
}

/**
 * Reports whether a string is a credential regardless of where it came from.
 *
 * @param value - The string to inspect.
 * @returns `true` when it matches one of the credential shapes.
 */
export function isSecretValue(value: string): boolean {
  return secretValuePatterns.some((pattern) => pattern.test(value));
}

/**
 * Walks a value, replacing credentials, and stops at {@link maximumDepth}.
 *
 * @param value - The value at this level.
 * @param depth - How far the walk has already gone.
 * @param seen - Objects already visited, so a cycle terminates.
 * @returns The redacted value.
 */
function redactAtDepth(value: unknown, depth: number, seen: WeakSet<object>): unknown {
  if (typeof value === "string") return isSecretValue(value) ? REDACTED : value;
  if (value === null || typeof value !== "object") return value;
  if (depth >= maximumDepth) return "[depth limit]";
  if (seen.has(value)) return "[circular]";

  seen.add(value);

  if (Array.isArray(value)) {
    return value.map((entry) => redactAtDepth(entry, depth + 1, seen));
  }

  if (value instanceof Error) {
    return {
      name: value.name,
      message: redactAtDepth(value.message, depth + 1, seen),
      ...(value.cause === undefined ? {} : { cause: redactAtDepth(value.cause, depth + 1, seen) }),
    };
  }

  const result: Record<string, unknown> = {};
  for (const [key, entry] of Object.entries(value)) {
    result[key] = isSecretFieldName(key) ? REDACTED : redactAtDepth(entry, depth + 1, seen);
  }

  return result;
}
