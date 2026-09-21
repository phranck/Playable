import { describe, expect, it } from "vitest";
import { isUsableSlug, maximumSlugLength, reservedPathSegments, slugFromTitle } from "./slug.js";

describe("slugFromTitle", () => {
  it("lowercases and joins with single hyphens", () => {
    expect(slugFromTitle("The Morning Show")).toBe("the-morning-show");
  });

  it("spells out German vowels rather than dropping them", () => {
    expect(slugFromTitle("Österreich Heute")).toBe("oesterreich-heute");
    expect(slugFromTitle("Für alle")).toBe("fuer-alle");
    expect(slugFromTitle("Grüße")).toBe("gruesse");
  });

  it("strips diacritics that have no German spelling", () => {
    expect(slugFromTitle("Café Crème")).toBe("cafe-creme");
  });

  it("collapses punctuation and runs of separators", () => {
    expect(slugFromTitle("Tech // Talk --- 2026!")).toBe("tech-talk-2026");
  });

  it("leaves no hyphen at either end", () => {
    expect(slugFromTitle("  ...Radio...  ")).toBe("radio");
  });

  it("keeps within the length bound without ending on a hyphen", () => {
    const slug = slugFromTitle(`${"wort ".repeat(40)}`);

    expect(slug.length).toBeLessThanOrEqual(maximumSlugLength);
    expect(slug.endsWith("-")).toBe(false);
  });

  it("returns nothing when a title has nothing to make a slug of", () => {
    expect(slugFromTitle("!!! ??? ...")).toBe("");
  });
});

describe("isUsableSlug", () => {
  it("accepts a well formed slug", () => {
    expect(isUsableSlug("the-morning-show")).toBe(true);
  });

  it.each([...reservedPathSegments])("refuses the reserved path %s", (segment) => {
    expect(isUsableSlug(segment)).toBe(false);
  });

  it.each([
    "",
    "Uppercase",
    "two--hyphens",
    "-leading",
    "trailing-",
    "with space",
    "with/slash",
    "with.dot",
  ])("refuses %s", (candidate) => {
    expect(isUsableSlug(candidate)).toBe(false);
  });

  it("refuses a slug past the length bound", () => {
    expect(isUsableSlug("a".repeat(maximumSlugLength + 1))).toBe(false);
  });

  it("accepts everything slugFromTitle produces from a real title", () => {
    for (const title of ["Der Podcast über Österreich", "Tech Talk 2026", "Café Crème"]) {
      expect(isUsableSlug(slugFromTitle(title)), title).toBe(true);
    }
  });
});

describe("reservedPathSegments", () => {
  it("includes the path the apps claim", () => {
    expect(reservedPathSegments.has("live")).toBe(true);
  });

  it("holds only entries that are themselves well formed path segments", () => {
    for (const segment of reservedPathSegments) {
      expect(segment, `${segment} is not a plain path segment`).not.toContain("/");
      expect(segment).toBe(segment.toLowerCase());
    }
  });
});
