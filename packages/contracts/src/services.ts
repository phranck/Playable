/**
 * Canonical names of the deployable Playable services.
 *
 * Every workspace that has to name a service uses these members rather than a
 * string of its own. The names appear in the deployment definition, in service
 * discovery URLs between containers, and in configuration keys, so a typo in
 * one place and a rename in another are the two failures this namespace exists
 * to prevent.
 */
export const PlayableService = {
  /** The HTTP API that serves the public and internal Playable endpoints. */
  Backend: "backend",
  /** The public playable.at site, including the live share routes. */
  Website: "website",
  /** The internal operations dashboard behind its audit boundary. */
  Dashboard: "dashboard",
  /** The PostgreSQL instance that owns every persisted record. */
  Database: "database",
} as const;

/**
 * The name of one deployable Playable service.
 *
 * Deriving the type from {@link PlayableService} keeps the union and the values
 * in step, so a service added to the namespace needs no second edit here.
 */
export type PlayableServiceName = (typeof PlayableService)[keyof typeof PlayableService];

/**
 * Every service name in declaration order.
 *
 * The deployment definition and the configuration inventory both iterate the
 * complete set, and iterating the namespace directly would expose the member
 * keys rather than the wire names.
 */
export const playableServiceNames: readonly PlayableServiceName[] = Object.values(PlayableService);

/**
 * Reports whether an arbitrary value is a canonical Playable service name.
 *
 * Configuration and deployment metadata arrive as plain strings, so this is the
 * point at which such a string becomes a typed service name.
 *
 * @param value - Any value, typically read from configuration or a request.
 * @returns `true` when the value is one of the names in {@link PlayableService}.
 */
export function isPlayableServiceName(value: unknown): value is PlayableServiceName {
  return typeof value === "string" && playableServiceNames.includes(value as PlayableServiceName);
}
