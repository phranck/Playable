import { describe, expect, it } from "vitest";
import {
  isWellFormedChannelId,
  liveRouteSegment,
  liveShareUrl,
  maximumChannelIdLength,
  parseShareRoute,
  podcastPageUrl,
  ShareRouteKind,
} from "./shareUrl.js";
import { reservedPathSegments } from "./slug.js";

const origin = "https://playable.at";

/** A Parse object ID, which is what Podlive shares today. */
const parseObjectId = "Ab3Cd5Ef7G";

describe("liveShareUrl", () => {
  it("puts the identifier below the path the apps claim", () => {
    expect(liveShareUrl(parseObjectId, origin)).toBe(`${origin}/${liveRouteSegment}/${parseObjectId}`);
  });

  it("accepts an origin with a trailing separator without doubling it", () => {
    expect(liveShareUrl(parseObjectId, "https://playable.at/")).toBe(`${origin}/live/${parseObjectId}`);
  });

  it("builds the same shape for a preview origin", () => {
    expect(liveShareUrl(parseObjectId, "https://preview.playable.at")).toBe(
      `https://preview.playable.at/live/${parseObjectId}`,
    );
  });

  it("refuses to build a broken link", () => {
    expect(() => liveShareUrl("../../etc", origin)).toThrow(RangeError);
    expect(() => liveShareUrl("", origin)).toThrow(RangeError);
  });
});

describe("podcastPageUrl", () => {
  it("puts the slug at the root", () => {
    expect(podcastPageUrl("the-morning-show", origin)).toBe(`${origin}/the-morning-show`);
  });

  it("refuses a slug the site owns", () => {
    expect(() => podcastPageUrl("privacy", origin)).toThrow(RangeError);
  });
});

describe("isWellFormedChannelId", () => {
  it("accepts a Parse object ID", () => {
    expect(isWellFormedChannelId(parseObjectId)).toBe(true);
  });

  it("accepts an identifier shaped differently, since the format is not fixed yet", () => {
    expect(isWellFormedChannelId("01J9Z4Q2K7XN_a-b")).toBe(true);
  });

  it.each([
    "",
    "../etc",
    "has space",
    "has/slash",
    "has.dot",
    "-leading",
    "has%20escape",
  ])("refuses %s", (candidate) => {
    expect(isWellFormedChannelId(candidate)).toBe(false);
  });

  it("refuses an identifier past the length bound", () => {
    expect(isWellFormedChannelId("a".repeat(maximumChannelIdLength + 1))).toBe(false);
  });
});

describe("parseShareRoute", () => {
  it("reads a live share link", () => {
    expect(parseShareRoute(`${origin}/live/${parseObjectId}`)).toEqual({
      kind: ShareRouteKind.Live,
      channelId: parseObjectId,
    });
  });

  it("reads a bare path, which is what a server hands it", () => {
    expect(parseShareRoute(`/live/${parseObjectId}`)).toEqual({
      kind: ShareRouteKind.Live,
      channelId: parseObjectId,
    });
  });

  it("reads a podcast page", () => {
    expect(parseShareRoute(`${origin}/the-morning-show`)).toEqual({
      kind: ShareRouteKind.Podcast,
      slug: "the-morning-show",
    });
  });

  it("refuses a malformed identifier rather than passing it on", () => {
    expect(parseShareRoute(`${origin}/live/has%20space`)).toBeUndefined();
    expect(parseShareRoute(`${origin}/live/`)).toBeUndefined();
  });

  it.each([...reservedPathSegments])("does not read the reserved path %s as a podcast", (segment) => {
    expect(parseShareRoute(`${origin}/${segment}`)).toBeUndefined();
  });

  it("refuses a path deeper than the scheme defines", () => {
    expect(parseShareRoute(`${origin}/live/${parseObjectId}/extra`)).toBeUndefined();
  });

  it("refuses an address carrying credentials", () => {
    expect(parseShareRoute(`https://someone:secret@playable.at/live/${parseObjectId}`)).toBeUndefined();
  });

  it("refuses a scheme that is not the web", () => {
    expect(parseShareRoute(`javascript:alert(1)`)).toBeUndefined();
    expect(parseShareRoute(`file:///live/${parseObjectId}`)).toBeUndefined();
  });

  it("refuses something that is not an address at all", () => {
    expect(parseShareRoute("not a url")).toBeUndefined();
  });

  it("reads back what it builds", () => {
    expect(parseShareRoute(liveShareUrl(parseObjectId, origin))).toEqual({
      kind: ShareRouteKind.Live,
      channelId: parseObjectId,
    });
    expect(parseShareRoute(podcastPageUrl("the-morning-show", origin))).toEqual({
      kind: ShareRouteKind.Podcast,
      slug: "the-morning-show",
    });
  });
});
