/**
 * What resolving a share address concluded, and what a browser is told.
 *
 * The outcomes are separate from the lookup on purpose. Deciding is a rule and
 * can be tested without a database; looking up is not.
 */
export const ShareResolutionKind = {
  /** The address names a podcast that is published under exactly this address. */
  Found: "found",
  /** The address is a form the podcast used to have. */
  Moved: "moved",
  /** Nothing here has ever been published under this address. */
  NotFound: "not_found",
  /** Something was published here and has been withdrawn. */
  Gone: "gone",
} as const;

/** One of the outcomes in {@link ShareResolutionKind}. */
export type ShareResolutionKind = (typeof ShareResolutionKind)[keyof typeof ShareResolutionKind];

/** The outcome of resolving one address. */
export type ShareResolution =
  | { kind: typeof ShareResolutionKind.Found }
  | { kind: typeof ShareResolutionKind.Moved; canonicalSlug: string }
  | { kind: typeof ShareResolutionKind.NotFound }
  | { kind: typeof ShareResolutionKind.Gone };

/** What the catalogue knows about one podcast's addresses. */
export interface PodcastAddresses {
  /** The slug the podcast is published under now. */
  currentSlug: string;
  /**
   * Every slug it has been published under before.
   *
   * These are never released to another podcast. A slug that could be taken by
   * a different show would make every link shared before the rename resolve to
   * somebody else's podcast, and that link keeps working, so nothing reports
   * it. Holding the old slug for ever is the only version of this that is
   * safe, and it is why the store keeps the list rather than only the current
   * name.
   */
  historicalSlugs: readonly string[];
  /** Whether the podcast has been withdrawn from publication. */
  withdrawn: boolean;
}

/**
 * Decides what an incoming slug resolves to.
 *
 * @param slug - The slug from the address.
 * @param addresses - What the catalogue holds for the podcast that owns this
 *   slug, or `undefined` when no podcast has ever owned it.
 * @returns The outcome. A historical slug is `Moved` rather than `Found`, so
 *   the reader ends up at one address rather than two and a search engine is
 *   not offered the same podcast twice.
 */
export function resolveSlug(slug: string, addresses: PodcastAddresses | undefined): ShareResolution {
  if (addresses === undefined) return { kind: ShareResolutionKind.NotFound };
  if (addresses.withdrawn) return { kind: ShareResolutionKind.Gone };

  if (slug === addresses.currentSlug) return { kind: ShareResolutionKind.Found };

  if (addresses.historicalSlugs.includes(slug)) {
    return { kind: ShareResolutionKind.Moved, canonicalSlug: addresses.currentSlug };
  }

  return { kind: ShareResolutionKind.NotFound };
}

/**
 * The status a browser is answered with.
 *
 * `Moved` is permanent rather than temporary. A rename is not expected to be
 * undone, and a permanent answer lets a client and a search engine stop asking
 * for the old address.
 *
 * A live stream that has ended is deliberately absent from this. It is not a
 * failure: the podcast exists and its page is served with a state saying the
 * stream is over, because somebody who followed a shared link deserves to see
 * whose stream it was rather than a not-found page.
 *
 * @param resolution - What resolving concluded.
 * @returns The HTTP status to answer with.
 */
export function httpStatusForShareResolution(resolution: ShareResolution): 200 | 301 | 404 | 410 {
  switch (resolution.kind) {
    case ShareResolutionKind.Found:
      return 200;
    case ShareResolutionKind.Moved:
      return 301;
    case ShareResolutionKind.Gone:
      return 410;
    case ShareResolutionKind.NotFound:
      return 404;
  }
}
