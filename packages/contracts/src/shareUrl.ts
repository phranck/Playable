import { isUsableSlug } from "./slug.js";

/**
 * The two addresses a podcast has, and what each is for.
 *
 * `/<slug>` is what a person shares. It reads as the podcast's name, so it
 * survives being pasted into a message and tells the reader what they are
 * about to open.
 *
 * `/live/<id>` carries an identifier instead of a name. It never changes, it
 * exists before a podcast has a slug, and it is what Podlive shares today
 * using Parse object identifiers.
 *
 * Both open an installed app. That needs the apps to claim the root of the
 * site with every path the site owns excluded first, which is what
 * {@link reservedPathSegments} is for and why an exclusion list has to exist
 * before the first slug is minted rather than after one collides.
 */
export const ShareRouteKind = {
  /** `/live/<id>`, the address that carries an identifier rather than a name. */
  Live: "live",
  /** `/<slug>`, the readable address a person shares. */
  Podcast: "podcast",
} as const;

/** One of the kinds in {@link ShareRouteKind}. */
export type ShareRouteKind = (typeof ShareRouteKind)[keyof typeof ShareRouteKind];

/** The segment that introduces an identifier, keeping it clear of the slug namespace. */
export const liveRouteSegment = "live";

/** A parsed Playable address. */
export type ShareRoute =
  | { kind: typeof ShareRouteKind.Live; channelId: string }
  | { kind: typeof ShareRouteKind.Podcast; slug: string };

/**
 * The longest an identifier may be.
 *
 * Playable's own identifiers do not exist yet and Podlive's are ten-character
 * Parse object IDs, so the bound is generous. Its job is not to describe a
 * format but to stop an arbitrarily long string reaching a lookup.
 */
export const maximumChannelIdLength = 64;

/**
 * Reports whether a string is shaped like an identifier Playable would issue.
 *
 * The identifier is deliberately opaque here. Podlive shares Parse object IDs
 * today and Playable will share canonical identifiers of its own once the
 * legacy history is imported, and neither the URL shape nor this check should
 * have to change between the two. What is checked is that the value is a safe
 * token, so a malformed address is rejected before anything looks it up.
 *
 * @param channelId - The candidate identifier from a path.
 * @returns `true` when it is a plausible identifier.
 */
export function isWellFormedChannelId(channelId: string): boolean {
  if (channelId.length === 0 || channelId.length > maximumChannelIdLength) return false;

  return /^[A-Za-z0-9][A-Za-z0-9_-]*$/.test(channelId);
}

/**
 * Builds the identifier-based address of a live stream.
 *
 * It carries no part of the podcast's name, so it survives a rename and it
 * exists before a podcast has a slug at all. Podlive shares this form today,
 * because a Parse object identifier is all it has.
 *
 * @param channelId - The channel's identifier.
 * @param origin - Where the site is published, such as `https://playable.at`.
 *   Passed in rather than fixed, because Podlive builds the same address and
 *   a preview deployment builds it against its own origin.
 * @returns The absolute address.
 * @throws {RangeError} When the identifier is not well formed, since a broken
 *   share link is worse than no share button.
 */
export function liveShareUrl(channelId: string, origin: string): string {
  if (!isWellFormedChannelId(channelId)) {
    throw new RangeError(`"${channelId}" is not a well formed channel identifier.`);
  }

  return `${trimTrailingSlash(origin)}/${liveRouteSegment}/${channelId}`;
}

/**
 * Builds the readable address of a podcast.
 *
 * This is the one to offer a person who is sharing. It reads as the podcast's
 * name, and it changes when the podcast is renamed, which is why every slug it
 * has ever had keeps pointing at it.
 *
 * @param slug - The podcast's current slug.
 * @param origin - Where the site is published.
 * @returns The absolute address.
 * @throws {RangeError} When the slug is reserved or malformed.
 */
export function podcastPageUrl(slug: string, origin: string): string {
  if (!isUsableSlug(slug)) {
    throw new RangeError(`"${slug}" is not a usable slug.`);
  }

  return `${trimTrailingSlash(origin)}/${slug}`;
}

/**
 * Works out what an incoming address refers to.
 *
 * Used by the website to route a request and by an app to decide what a link
 * it was handed means. It answers `undefined` rather than guessing, so an
 * address that is not Playable's own never starts playback of something else.
 *
 * @param url - The address, absolute or as a path.
 * @returns What it refers to, or `undefined` when it refers to nothing here.
 */
export function parseShareRoute(url: string): ShareRoute | undefined {
  const path = pathOf(url);
  if (path === undefined) return undefined;

  const segments = path.split("/").filter((segment) => segment !== "");

  if (segments.length === 2 && segments[0] === liveRouteSegment) {
    const channelId = segments[1] as string;
    return isWellFormedChannelId(channelId) ? { kind: ShareRouteKind.Live, channelId } : undefined;
  }

  if (segments.length === 1) {
    const slug = segments[0] as string;
    return isUsableSlug(slug) ? { kind: ShareRouteKind.Podcast, slug } : undefined;
  }

  return undefined;
}

/**
 * Extracts the path from something that may be an address or already a path.
 *
 * An address carrying credentials is refused outright. Nothing legitimate
 * produces one, and accepting it would let a crafted link reach a lookup with
 * a value that looks like it came from Playable.
 */
function pathOf(url: string): string | undefined {
  if (url.startsWith("/")) return url;

  let parsed: URL;
  try {
    parsed = new URL(url);
  } catch {
    return undefined;
  }

  if (parsed.protocol !== "https:" && parsed.protocol !== "http:") return undefined;
  if (parsed.username !== "" || parsed.password !== "") return undefined;

  return parsed.pathname;
}

/** Removes a trailing separator so joining a path never doubles it. */
function trimTrailingSlash(origin: string): string {
  return origin.endsWith("/") ? origin.slice(0, -1) : origin;
}
