/**
 * The four places Playable runs.
 *
 * This is separate from `NODE_ENV` on purpose. `NODE_ENV` has three values and
 * libraries read it to decide whether to optimize, cache and hide stack traces.
 * Playable has four places to run, and preview and staging are both
 * `production` as far as any library is concerned whilst being nothing like
 * production as far as data and credentials are concerned. Collapsing the two
 * questions into one variable is how a preview deployment ends up pointed at
 * production data.
 */
export const PlayableEnvironment = {
  /** A developer's machine. Uses the local database and no remote credential. */
  Local: "local",
  /** A throwaway deployment of a branch, with its own data. */
  Preview: "preview",
  /** The rehearsal of production, with its own data. */
  Staging: "staging",
  /** What listeners use. */
  Production: "production",
} as const;

/** One of the environments in {@link PlayableEnvironment}. */
export type PlayableEnvironment = (typeof PlayableEnvironment)[keyof typeof PlayableEnvironment];

/** Every environment name, in order of how close it is to listeners. */
export const playableEnvironments: readonly PlayableEnvironment[] = Object.values(PlayableEnvironment);

/**
 * The environments that must never see a production credential.
 *
 * Membership is what the configuration loader checks before accepting a
 * database URL, so adding an environment here is the only edit needed to bring
 * it under that protection.
 */
export const developmentEnvironments: readonly PlayableEnvironment[] = [PlayableEnvironment.Local];

/**
 * Reports whether a value names a Playable environment.
 *
 * @param value - Any value, typically read from the process environment.
 * @returns `true` when the value is one of {@link playableEnvironments}.
 */
export function isPlayableEnvironment(value: unknown): value is PlayableEnvironment {
  return typeof value === "string" && playableEnvironments.includes(value as PlayableEnvironment);
}
