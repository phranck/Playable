/**
 * The readable part of a podcast's address on the web.
 *
 * A slug sits at the root of the site, so it competes with every other route
 * the site has. That is why {@link reservedPathSegments} exists and why a slug
 * is checked against it rather than simply lowercased.
 */

/**
 * How German writes the vowels that ASCII does not have.
 *
 * Folding to the bare letter would turn "Österreich" into "sterreich" once the
 * diacritic is stripped, or "Osterreich", which is a different word. German
 * spells them out, so "Österreich" becomes "oesterreich" and a listener typing
 * what they read arrives in the right place.
 */
const germanFoldings: ReadonlyArray<readonly [RegExp, string]> = [
  [/ä/g, "ae"],
  [/ö/g, "oe"],
  [/ü/g, "ue"],
  [/ß/g, "ss"],
];

/**
 * The longest a slug may be.
 *
 * Long enough for a real podcast title, short enough that the whole address
 * survives being pasted into a message without being wrapped or shortened by
 * something that then breaks it.
 */
export const maximumSlugLength = 80;

/**
 * Paths a slug may never take.
 *
 * The site owns these, and a podcast that claimed one would take a page away
 * from the site rather than merely clashing with it. The list is checked when
 * a slug is minted, so the collision cannot happen rather than being resolved
 * afterwards by whoever was there first.
 */
export const reservedPathSegments: ReadonlySet<string> = new Set([
  // The share path and everything the platform serves.
  "live",
  "api",
  "docs",
  "dashboard",
  "health",
  // Ordinary site pages, including the ones an Austrian site is obliged to have.
  "about",
  "imprint",
  "impressum",
  "privacy",
  "datenschutz",
  "terms",
  "legal",
  "contact",
  "search",
  "download",
  "app",
  // Account and session pages, whether or not they exist yet. A slug minted
  // before the page is built would have to be taken away from somebody later.
  "account",
  "login",
  "logout",
  "signup",
  "register",
  "settings",
  "subscribe",
  // Files and directories a site serves from its root.
  "assets",
  "static",
  "public",
  "favicon.ico",
  "robots.txt",
  "sitemap.xml",
  "manifest.json",
  ".well-known",
]);

/**
 * Turns a podcast title into the readable part of its address.
 *
 * The result is lowercase, joined by single hyphens, and free of anything a
 * URL would have to escape. German vowels are spelled out rather than
 * stripped, so a title stays recognisable.
 *
 * @param title - The podcast's title, as a person wrote it.
 * @returns The slug, or an empty string when the title has nothing a slug can
 *   be made of, such as a title consisting only of punctuation. The caller
 *   decides what to do about that, because falling back to an identifier here
 *   would hide it.
 */
export function slugFromTitle(title: string): string {
  let slug = title.toLowerCase();

  for (const [pattern, replacement] of germanFoldings) {
    slug = slug.replace(pattern, replacement);
  }

  return slug
    .normalize("NFD")
    .replaceAll(/[̀-ͯ]/g, "")
    .replaceAll(/[^a-z0-9]+/g, "-")
    .replaceAll(/^-+|-+$/g, "")
    .slice(0, maximumSlugLength)
    .replaceAll(/-+$/g, "");
}

/**
 * Reports whether a string is usable as a slug.
 *
 * A slug that is reserved or malformed is rejected when it is minted rather
 * than when somebody visits it, so the failure lands on whoever can still
 * choose a different one.
 *
 * @param slug - The candidate.
 * @returns `true` when it is well formed and not a path the site owns.
 */
export function isUsableSlug(slug: string): boolean {
  if (slug.length === 0 || slug.length > maximumSlugLength) return false;
  if (reservedPathSegments.has(slug)) return false;

  return /^[a-z0-9]+(-[a-z0-9]+)*$/.test(slug);
}
