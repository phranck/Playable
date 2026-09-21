/**
 * What a channel's state is called in the legacy source.
 *
 * The names come from the Podlive app, which stores them as strings and maps
 * them by position. They are reproduced here rather than reinterpreted,
 * because the site and the app have to agree about who is on air.
 */
export const ChannelState = {
  /** About to start. Counts as on air. */
  Preshow: "preshow",
  /** Streaming. */
  Live: "live",
  /** Just finished, still on air. */
  Postshow: "postshow",
  /** Not streaming and not reachable. */
  Offline: "offline",
  /** Reachable and not streaming. Does not count as on air. */
  Online: "online",
  /** Paused mid-show. Counts as on air. */
  Break: "break",
  /** A test transmission. Counts as on air. */
  Test: "test",
} as const;

/** One of the states in {@link ChannelState}. */
export type ChannelState = (typeof ChannelState)[keyof typeof ChannelState];

/** Every state name, in the order the legacy source maps them. */
export const channelStates: readonly ChannelState[] = Object.values(ChannelState);

/**
 * The states that do not count as being on air.
 *
 * This is the definition that is easy to get wrong, and the only one that
 * matters for the overview. Podlive treats a channel as live whenever its
 * state is anything other than these two or unknown, so `preshow`, `postshow`,
 * `break` and `test` all appear as on air.
 *
 * `online` is the trap. It reads as though it meant live and means the
 * opposite: reachable, not transmitting. A site that took it at face value
 * would list podcasts the app does not, and the two would disagree about who
 * is on air in a way nobody would think to check.
 */
const statesThatAreNotOnAir: ReadonlySet<string> = new Set([ChannelState.Offline, ChannelState.Online]);

/**
 * What the site publishes about one channel.
 *
 * A deliberate subset of what the legacy source holds. That source carries an
 * address and a creator's name alongside the rest, and a public page is not
 * the place for either, so this type lists what may be served rather than
 * omitting what may not. A field added to the source does not become public by
 * appearing.
 */
export interface LiveChannel {
  /** The channel's stable identifier, which is what a share link carries. */
  id: string;
  /** The podcast's name. */
  name: string;
  /** What the podcast is about, when it says. */
  description?: string;
  /** The cover image, when there is one. */
  coverUrl?: string;
  /** The podcast's own site, when it has one. */
  websiteUrl?: string;
  /** Where the conversation happens during a show, when there is one. */
  chatUrl?: string;
  /** The state as the legacy source reports it. */
  state: ChannelState;
  /** Whether the state counts as being on air. */
  onAir: boolean;
  /** How many people are listening now. */
  listenerCount: number;
}

/**
 * Reports whether a state name counts as being on air.
 *
 * @param state - The state as the legacy source spells it, or anything else.
 * @returns `true` when Podlive would show this channel as live.
 */
export function isOnAir(state: string): boolean {
  if (!channelStates.includes(state as ChannelState)) return false;

  return !statesThatAreNotOnAir.has(state);
}

/**
 * Reports whether a value is one of the known state names.
 *
 * @param value - Any value, typically read from the legacy source.
 * @returns `true` when it is a member of {@link ChannelState}.
 */
export function isChannelState(value: unknown): value is ChannelState {
  return typeof value === "string" && channelStates.includes(value as ChannelState);
}

/**
 * Orders channels for the overview.
 *
 * Busiest first, because the listener count is the only signal on the page
 * about where something is happening. Ties fall back to the name so the order
 * does not change between two requests that found the same numbers.
 *
 * @param channels - The channels to order. Not modified.
 * @returns A new array in display order.
 */
export function sortedForOverview(channels: readonly LiveChannel[]): LiveChannel[] {
  return [...channels].sort(
    (left, right) => right.listenerCount - left.listenerCount || left.name.localeCompare(right.name),
  );
}
