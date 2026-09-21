import { describe, expect, it } from "vitest";
import {
  httpStatusForShareResolution,
  type PodcastAddresses,
  resolveSlug,
  ShareResolutionKind,
} from "./shareResolution.js";

/** A podcast that has been renamed once. */
const renamed: PodcastAddresses = {
  currentSlug: "mein-podcast-name",
  historicalSlugs: ["der-alte-name"],
  withdrawn: false,
};

describe("resolveSlug", () => {
  it("finds a podcast under its current address", () => {
    expect(resolveSlug("mein-podcast-name", renamed)).toEqual({ kind: ShareResolutionKind.Found });
  });

  it("moves a link shared before a rename to the current address", () => {
    expect(resolveSlug("der-alte-name", renamed)).toEqual({
      kind: ShareResolutionKind.Moved,
      canonicalSlug: "mein-podcast-name",
    });
  });

  it("reports nothing for a slug no podcast has ever held", () => {
    expect(resolveSlug("never-existed", undefined)).toEqual({ kind: ShareResolutionKind.NotFound });
  });

  it("reports a withdrawn podcast as gone rather than missing", () => {
    expect(resolveSlug("mein-podcast-name", { ...renamed, withdrawn: true })).toEqual({
      kind: ShareResolutionKind.Gone,
    });
  });

  it("reports a withdrawn podcast as gone through its old address too", () => {
    expect(resolveSlug("der-alte-name", { ...renamed, withdrawn: true })).toEqual({
      kind: ShareResolutionKind.Gone,
    });
  });

  it("never resolves a slug to a podcast that does not claim it", () => {
    expect(resolveSlug("someone-elses-name", renamed)).toEqual({ kind: ShareResolutionKind.NotFound });
  });
});

describe("httpStatusForShareResolution", () => {
  it("answers 200 for a podcast at its own address", () => {
    expect(httpStatusForShareResolution({ kind: ShareResolutionKind.Found })).toBe(200);
  });

  it("answers a permanent redirect for an old address", () => {
    expect(httpStatusForShareResolution({ kind: ShareResolutionKind.Moved, canonicalSlug: "mein-podcast-name" })).toBe(
      301,
    );
  });

  it("distinguishes withdrawn from never published", () => {
    expect(httpStatusForShareResolution({ kind: ShareResolutionKind.Gone })).toBe(410);
    expect(httpStatusForShareResolution({ kind: ShareResolutionKind.NotFound })).toBe(404);
  });
});
