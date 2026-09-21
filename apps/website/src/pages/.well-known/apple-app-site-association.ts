import { appLinkComponents } from "@playable/contracts";
import type { APIRoute } from "astro";

/**
 * The half of the Universal Link claim that belongs to the website.
 *
 * An app saying it is responsible for playable.at is not enough. macOS asks
 * the site whether that app may open its links, and this is the answer. Until
 * it is served, every shared link opens a browser however correct the app is,
 * and the app looks broken whilst nothing about it is wrong.
 *
 * Three things about serving it are easy to get wrong and all three fail
 * silently:
 *
 * It is served from the real domain over HTTPS, with no redirect on the way.
 * A redirect is treated as no file at all, which is why `www` serves its own
 * copy rather than being sent to the apex.
 *
 * It is `application/json` and the path carries no `.json` suffix.
 *
 * The answer is cached by Apple when an app arrives from TestFlight or the App
 * Store, so a wrong file is not fixed the moment it is corrected. It wants to
 * be right before the first build is installed.
 *
 * The components come from `@playable/contracts`, generated from the list of
 * paths the site owns, so a page added there cannot be forgotten here.
 */
export const prerender = false;

/** The apps allowed to open links on this site. */
const appIds = [
  // Podlive for macOS. Its team identifier and bundle identifier, in that order.
  "2Z5E3BGZR8.com.cocoanaut.Podlive",
];

export const GET: APIRoute = () => {
  const association = {
    applinks: {
      // Empty rather than absent: versions before iOS 13 read this key, and an
      // empty array is what tells them to use `details`.
      apps: [],
      details: [
        {
          appIDs: appIds,
          components: appLinkComponents(),
        },
      ],
    },
  };

  return new Response(JSON.stringify(association, null, 2), {
    headers: {
      "content-type": "application/json",
      // Long enough that the file is not fetched on every launch, short enough
      // that adding an app does not wait a day to take effect.
      "cache-control": "public, max-age=3600",
    },
  });
};
