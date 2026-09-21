import { isChannelState, isOnAir, type LiveChannel } from "@playable/contracts";

/**
 * Where the site gets its channels from.
 *
 * An interface rather than a direct call, because the site has to be buildable
 * and testable without the legacy credentials, and because #40 replaces the
 * implementation with Playable's own API without touching a page.
 */
export interface ChannelSource {
  /** Every channel the source knows, whatever state it is in. */
  allChannels(): Promise<LiveChannel[]>;
  /** One channel by identifier, or `undefined` when the source has none. */
  channel(id: string): Promise<LiveChannel | undefined>;
}

/**
 * The fields the legacy `Channel` class carries that the site reads.
 *
 * Deliberately not every field. `email` and `creator` are in that class as
 * well, and a public page is not the place for either, so they are absent here
 * rather than being fetched and then not rendered.
 */
interface LegacyChannelRecord {
  objectId?: unknown;
  name?: unknown;
  description?: unknown;
  coverartThumbnail200?: unknown;
  websiteUrl?: unknown;
  chatUrl?: unknown;
  state?: unknown;
  listenerCount?: unknown;
  isEnabled?: unknown;
}

/**
 * Turns one legacy record into what the site publishes.
 *
 * Every field is checked rather than trusted. The source predates this site by
 * years, so a record missing a name or carrying a state nobody has heard of is
 * an ordinary occurrence rather than a bug to crash on.
 *
 * @param record - One object as the legacy source returns it.
 * @returns The channel, or `undefined` when the record cannot be published:
 *   no identifier, no name, or switched off at the source.
 */
export function channelFromLegacyRecord(record: LegacyChannelRecord): LiveChannel | undefined {
  const id = asNonEmptyString(record.objectId);
  const name = asNonEmptyString(record.name);

  if (id === undefined || name === undefined) return undefined;
  if (record.isEnabled === false) return undefined;

  const state = isChannelState(record.state) ? record.state : "offline";

  return {
    id,
    name,
    ...optional("description", asNonEmptyString(record.description)),
    ...optional("coverUrl", asHttpsUrl(fileUrl(record.coverartThumbnail200))),
    ...optional("websiteUrl", asHttpsUrl(asNonEmptyString(record.websiteUrl))),
    ...optional("chatUrl", asHttpsUrl(asNonEmptyString(record.chatUrl))),
    state,
    onAir: isOnAir(state),
    listenerCount: asCount(record.listenerCount),
  };
}

/** A Parse file field is an object carrying the address under `url`. */
function fileUrl(value: unknown): string | undefined {
  if (typeof value === "string") return value;
  if (typeof value !== "object" || value === null) return undefined;

  return asNonEmptyString((value as { url?: unknown }).url);
}

/** Returns the value when it is a string with something in it. */
function asNonEmptyString(value: unknown): string | undefined {
  if (typeof value !== "string") return undefined;

  const trimmed = value.trim();
  return trimmed === "" ? undefined : trimmed;
}

/**
 * Returns the value when it is an address the page may load or link to.
 *
 * Anything that is not https is dropped rather than rendered. The legacy source
 * holds addresses entered by hand years ago, and one of them reaching an
 * attribute unchecked is the difference between a link and a script.
 */
function asHttpsUrl(value: string | undefined): string | undefined {
  if (value === undefined) return undefined;

  try {
    return new URL(value).protocol === "https:" ? value : undefined;
  } catch {
    return undefined;
  }
}

/** Reads a listener count, treating anything unusable as nobody listening. */
function asCount(value: unknown): number {
  const count = typeof value === "number" ? value : Number.NaN;

  return Number.isFinite(count) && count > 0 ? Math.floor(count) : 0;
}

/** Includes a field only when it has a value, so the shape stays free of undefined keys. */
function optional<Key extends string>(key: Key, value: string | undefined): Partial<Record<Key, string>> {
  return value === undefined ? {} : ({ [key]: value } as Record<Key, string>);
}
