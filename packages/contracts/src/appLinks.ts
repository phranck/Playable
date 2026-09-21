import { liveRouteSegment } from "./shareUrl.js";
import { reservedPathSegments } from "./slug.js";

/**
 * One entry of an Apple App Site Association `components` array.
 *
 * Only the keys Playable uses are modelled. The file accepts more, and a key
 * this does not carry is one nothing here relies on.
 */
export interface AppLinkComponent {
  /** The path pattern to match. */
  "/": string;
  /** Present and `true` when the pattern must not open the app. */
  exclude?: true;
  /** Why the entry exists, carried into the published file for whoever reads it. */
  comment: string;
}

/**
 * Builds the `components` array that claims Playable's addresses.
 *
 * Both a readable address and an identifier address open an installed app, and
 * the readable one sits at the root of the site. Claiming the root therefore
 * claims the privacy page and every other page with it, so every path the site
 * owns is excluded first.
 *
 * Order is the whole mechanism: the first matching entry decides, so the
 * exclusions have to precede the catch-all. Each excluded path needs two
 * entries, because a pattern ending in `/*` does not match the bare path it
 * was derived from.
 *
 * `/live` is the one reserved path that is not simply excluded. The site owns
 * the listing at `/live`, and the apps own every address below it, so the two
 * are claimed separately rather than together. A single exclusion for `live`
 * would quietly stop every identifier-based share link opening an app, and
 * nothing would report it: the link would keep working, in a browser.
 *
 * Generated rather than written by hand, so a path added to the reserved list
 * cannot be forgotten here. A site page missing from this array opens the app
 * instead of itself.
 *
 * @returns The entries, exclusions first, ending in the catch-all.
 * @see https://developer.apple.com/documentation/xcode/supporting-associated-domains
 */
export function appLinkComponents(): AppLinkComponent[] {
  const exclusions = [...reservedPathSegments]
    .filter((segment) => segment !== liveRouteSegment)
    .sort()
    .flatMap((segment): AppLinkComponent[] => [
      { "/": `/${segment}`, exclude: true, comment: `The site owns /${segment}` },
      { "/": `/${segment}/*`, exclude: true, comment: `The site owns everything below /${segment}` },
    ]);

  return [
    {
      "/": `/${liveRouteSegment}`,
      exclude: true,
      comment: `The site owns the listing at /${liveRouteSegment}`,
    },
    ...exclusions,
    {
      "/": `/${liveRouteSegment}/*`,
      comment: "An identifier-based share link opens the app",
    },
    { "/": "/*", comment: "Every remaining path is a podcast's readable address" },
  ];
}
