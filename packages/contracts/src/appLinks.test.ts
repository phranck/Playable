import { describe, expect, it } from "vitest";
import { type AppLinkComponent, appLinkComponents } from "./appLinks.js";
import { liveRouteSegment, liveShareUrl, podcastPageUrl } from "./shareUrl.js";
import { reservedPathSegments } from "./slug.js";

const components = appLinkComponents();

/**
 * Decides what the system would do with a path, the way the file is read.
 *
 * The first matching entry wins, whether it excludes or claims, which is the
 * part of the format that is easy to get wrong and impossible to see in the
 * finished file.
 *
 * @param path - The path from an incoming address.
 * @returns `true` when an installed app would open it.
 */
function opensTheApp(path: string): boolean {
  const match = components.find((component) => matches(component, path));
  return match !== undefined && match.exclude !== true;
}

/** Matches one entry's pattern against a path, with `*` standing for any run. */
function matches(component: AppLinkComponent, path: string): boolean {
  const pattern = component["/"]
    .replaceAll(/[.+^${}()|[\]\\]/g, String.raw`\$&`)
    .replaceAll("*", ".*")
    .replaceAll("?", ".");

  return new RegExp(`^${pattern}$`).test(path);
}

describe("appLinkComponents", () => {
  it("puts every exclusion before the catch-all", () => {
    const lastExclusion = components.findLastIndex((component) => component.exclude === true);
    const catchAll = components.findIndex((component) => component["/"] === "/*");

    expect(catchAll).toBeGreaterThan(lastExclusion);
  });

  it("ends with the catch-all", () => {
    expect(components.at(-1)?.["/"]).toBe("/*");
  });

  it("explains every entry", () => {
    for (const component of components) {
      expect(component.comment, component["/"]).toBeTruthy();
    }
  });

  it("opens the app for a readable share address", () => {
    expect(opensTheApp("/mein-podcast-name")).toBe(true);
  });

  it("opens the app for an identifier share address", () => {
    expect(opensTheApp(`/${liveRouteSegment}/Ab3Cd5Ef7G`)).toBe(true);
  });

  it("leaves the live listing to the site", () => {
    expect(opensTheApp(`/${liveRouteSegment}`)).toBe(false);
  });

  it.each(
    [...reservedPathSegments].filter((segment) => segment !== liveRouteSegment),
  )("leaves /%s to the site", (segment) => {
    expect(opensTheApp(`/${segment}`)).toBe(false);
    expect(opensTheApp(`/${segment}/anything`)).toBe(false);
  });

  it("opens the app for what the builders produce", () => {
    const origin = "https://playable.at";

    expect(opensTheApp(new URL(podcastPageUrl("mein-podcast-name", origin)).pathname)).toBe(true);
    expect(opensTheApp(new URL(liveShareUrl("Ab3Cd5Ef7G", origin)).pathname)).toBe(true);
  });
});
