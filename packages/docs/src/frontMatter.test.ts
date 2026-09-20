import { describe, expect, it } from "vitest";
import { GuidePosition, readFrontMatter } from "./frontMatter.js";

/**
 * Builds a document from its front matter lines and a fixed body.
 *
 * @param lines - The `key: value` lines to place between the fences.
 * @returns A complete Markdown document.
 */
function documentWith(lines: string[]): string {
  return ["---", ...lines, "---", "", "The body.", ""].join("\n");
}

const validLines = ["id: live-data", "title: Live data", "position: after-guide"];

describe("readFrontMatter", () => {
  it("reads a complete block", () => {
    const result = readFrontMatter(documentWith(validLines));

    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.frontMatter).toEqual({
      id: "live-data",
      title: "Live data",
      position: GuidePosition.AfterGuide,
    });
    expect(result.body).toBe("The body.");
  });

  it("keeps a colon inside a title", () => {
    const result = readFrontMatter(
      documentWith(["id: live-data", "title: Live data: what arrives when", "position: after-guide"]),
    );

    expect(result.ok).toBe(true);
    if (!result.ok) return;
    expect(result.frontMatter.title).toBe("Live data: what arrives when");
  });

  it("rejects a document without an opening fence", () => {
    const result = readFrontMatter("# Live data\n\nThe body.\n");

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems[0]?.reason).toContain("front matter fence");
  });

  it("rejects a block that is never closed", () => {
    const result = readFrontMatter(["---", ...validLines, "", "The body."].join("\n"));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems[0]?.reason).toContain("no closing");
  });

  it("rejects an unknown key", () => {
    const result = readFrontMatter(documentWith([...validLines, "author: someone"]));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems.some((problem) => problem.reason.includes('"author"'))).toBe(true);
  });

  it("rejects a repeated key", () => {
    const result = readFrontMatter(documentWith([...validLines, "id: live-data"]));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems.some((problem) => problem.reason.includes("more than once"))).toBe(true);
  });

  it("rejects a line that is not a pair", () => {
    const result = readFrontMatter(documentWith([...validLines, "just a sentence"]));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems.some((problem) => problem.reason.includes('"key: value"'))).toBe(true);
  });

  it("reports every missing key in one pass", () => {
    const result = readFrontMatter(documentWith([]));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems).toHaveLength(3);
  });

  it("rejects a position the generator does not accept", () => {
    const result = readFrontMatter(documentWith(["id: live-data", "title: Live data", "position: sidebar"]));

    expect(result.ok).toBe(false);
    if (result.ok) return;
    expect(result.problems.some((problem) => problem.reason.includes('"sidebar"'))).toBe(true);
  });

  it.each(["Live-Data", "live data", "live--data", "-live", "live-"])("rejects the id %s", (id) => {
    const result = readFrontMatter(documentWith([`id: ${id}`, "title: Live data", "position: after-guide"]));

    expect(result.ok).toBe(false);
  });

  it.each(Object.values(GuidePosition))("accepts the position %s", (position) => {
    const result = readFrontMatter(documentWith(["id: live-data", "title: Live data", `position: ${position}`]));

    expect(result.ok).toBe(true);
  });
});
