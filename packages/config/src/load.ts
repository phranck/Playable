import type { PlayableServiceName } from "@playable/contracts";
import { developmentEnvironments, isPlayableEnvironment, type PlayableEnvironment } from "./environments.js";
import { administrativeDatabaseUrlName, type ConfigurationEntry, entriesForService } from "./inventory.js";

/** The configuration one service starts with. */
export interface ServiceConfiguration {
  /** The service this configuration belongs to. */
  service: PlayableServiceName;
  /** Which deployment this is. */
  environment: PlayableEnvironment;
  /** Every variable the service reads, resolved and validated. */
  values: Readonly<Record<string, string>>;
}

/**
 * Raised when a service cannot be configured.
 *
 * It lists every problem rather than the first, because a person adding
 * variables one at a time to satisfy a restart learns about the next missing
 * one only after the next restart.
 */
export class ConfigurationError extends Error {
  /** Every reason the configuration was rejected, each a complete sentence. */
  readonly problems: readonly string[];

  /**
   * @param service - The service that could not be configured.
   * @param problems - Every reason, in the order they were found.
   */
  constructor(service: PlayableServiceName, problems: readonly string[]) {
    super(`The ${service} service cannot start:\n${problems.map((problem) => `  - ${problem}`).join("\n")}`);
    this.name = "ConfigurationError";
    this.problems = problems;
  }
}

/** Hosts a local database is allowed to answer on. */
const localHosts = new Set(["localhost", "127.0.0.1", "::1", "[::1]"]);

/**
 * Resolves and validates the configuration of one service.
 *
 * @param service - The service being configured.
 * @param environment - The process environment, passed in rather than read from
 *   `process.env` so that tests configure a service without touching the
 *   process they run in.
 * @returns The resolved configuration.
 * @throws {ConfigurationError} When any required variable is missing, holds a
 *   value outside its accepted set, or points a development environment at a
 *   credential it must not reach.
 */
export function loadServiceConfiguration(
  service: PlayableServiceName,
  environment: NodeJS.ProcessEnv,
): ServiceConfiguration {
  const problems: string[] = [];
  const values: Record<string, string> = {};

  for (const entry of entriesForService(service)) {
    const resolved = resolve(entry, environment, problems);
    if (resolved !== undefined) values[entry.name] = resolved;
  }

  const deployment = values.PLAYABLE_ENVIRONMENT;

  if (isPlayableEnvironment(deployment) && developmentEnvironments.includes(deployment)) {
    problems.push(...developmentCredentialProblems(values, environment, deployment));
  }

  if (problems.length > 0) throw new ConfigurationError(service, problems);

  if (!isPlayableEnvironment(deployment)) {
    // Unreachable: PLAYABLE_ENVIRONMENT is in every service's inventory entry
    // with a closed set of values, so an invalid one has already thrown above.
    throw new ConfigurationError(service, [`PLAYABLE_ENVIRONMENT resolved to "${deployment}".`]);
  }

  return { service, environment: deployment, values };
}

/**
 * Resolves one entry, recording any reason it could not be used.
 *
 * @param entry - The inventory entry being resolved.
 * @param environment - The process environment.
 * @param problems - Collector the caller reads, appended to in place.
 * @returns The resolved value, or `undefined` when it could not be resolved.
 */
function resolve(entry: ConfigurationEntry, environment: NodeJS.ProcessEnv, problems: string[]): string | undefined {
  const raw = environment[entry.name];
  const value = raw === undefined || raw === "" ? entry.fallback : raw;

  if (value === undefined) {
    problems.push(`${entry.name} is required and not set. ${entry.purpose}`);
    return undefined;
  }

  if (entry.allowed && !entry.allowed.includes(value)) {
    problems.push(`${entry.name} is "${value}", which is not one of ${entry.allowed.join(", ")}.`);
    return undefined;
  }

  return value;
}

/**
 * Reports credentials a development environment must not be given.
 *
 * A local run that reaches a remote database answers every query, and each
 * answer is about somebody else's data. That failure looks like working
 * software, which is why it is rejected here rather than left to notice.
 *
 * @param values - The resolved values of the service.
 * @param environment - The process environment, read for the administrative
 *   connection that is deliberately absent from the inventory.
 * @param deployment - The environment being protected.
 * @returns One sentence per problem, empty when there is none.
 */
function developmentCredentialProblems(
  values: Readonly<Record<string, string>>,
  environment: NodeJS.ProcessEnv,
  deployment: PlayableEnvironment,
): string[] {
  const problems: string[] = [];
  const databaseUrl = values.DATABASE_URL;

  if (databaseUrl !== undefined && !isLocalDatabaseUrl(databaseUrl)) {
    problems.push(
      `DATABASE_URL points somewhere other than this machine, which PLAYABLE_ENVIRONMENT=${deployment} must never do. Use the local PostgreSQL instance.`,
    );
  }

  if (environment[administrativeDatabaseUrlName] !== undefined) {
    problems.push(
      `${administrativeDatabaseUrlName} is set, and no service may start with it. It exists for one approved repair at a time and never for a running service.`,
    );
  }

  return problems;
}

/**
 * Reports whether a connection string addresses this machine.
 *
 * A string that cannot be parsed counts as not local, because a value the
 * loader does not understand is not one it can vouch for.
 *
 * @param databaseUrl - The connection string to inspect.
 * @returns `true` when the host is a loopback address.
 */
function isLocalDatabaseUrl(databaseUrl: string): boolean {
  try {
    return localHosts.has(new URL(databaseUrl).hostname);
  } catch {
    return false;
  }
}
