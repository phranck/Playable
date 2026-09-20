import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterEach, beforeEach, describe, expect, it } from "vitest";
import { privateDocumentationDirectory, publicDocumentationDirectory, readPublicGuides } from "./publicGuides.js";

let repositoryRoot: string;

/**
 * Writes a document below the documentation directory of the fixture repository.
 *
 * @param relativePath - Path below `Documentations`, including the file name.
 * @param contents - The complete file contents.
 */
async function writeDocument(relativePath: string, contents: string): Promise<void> {
  const absolutePath = join(repositoryRoot, publicDocumentationDirectory, relativePath);
  await mkdir(join(absolutePath, ".."), { recursive: true });
  await writeFile(absolutePath, contents, "utf8");
}

/**
 * Builds a valid guide document.
 *
 * @param id - The guide id, also used to make the title recognizable.
 * @returns A complete Markdown document.
 */
function guide(id: string): string {
  return ["---", `id: ${id}`, `title: Guide ${id}`, "position: after-guide", "---", "", `Body of ${id}.`, ""].join(
    "\n",
  );
}

beforeEach(async () => {
  repositoryRoot = await mkdtemp(join(tmpdir(), "playable-docs-test-"));
});

afterEach(async () => {
  await rm(repositoryRoot, { recursive: true, force: true });
});

describe("readPublicGuides", () => {
  it("returns nothing when the documentation directory is absent", async () => {
    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides).toEqual([]);
    expect(result.problems).toEqual([]);
  });

  it("reads a guide and its body", async () => {
    await writeDocument("live-data.md", guide("live-data"));

    const result = await readPublicGuides(repositoryRoot);

    expect(result.problems).toEqual([]);
    expect(result.guides).toHaveLength(1);
    expect(result.guides[0]).toMatchObject({
      id: "live-data",
      title: "Guide live-data",
      position: "after-guide",
      markdown: "Body of live-data.",
      sourcePath: join(publicDocumentationDirectory, "live-data.md"),
    });
  });

  it("orders guides by id rather than by file system order", async () => {
    await writeDocument("zulu.md", guide("zulu"));
    await writeDocument("alpha.md", guide("alpha"));

    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides.map((entry) => entry.id)).toEqual(["alpha", "zulu"]);
  });

  it("finds guides in subdirectories", async () => {
    await writeDocument("integration/webhooks.md", guide("webhooks"));

    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides.map((entry) => entry.id)).toEqual(["webhooks"]);
  });

  it("skips everything below the private directory", async () => {
    await writeDocument(join(privateDocumentationDirectory, "secrets.md"), "no front matter here");

    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides).toEqual([]);
    expect(result.problems).toEqual([]);
  });

  it("skips the directory README", async () => {
    await writeDocument("README.md", "# Documentations\n\nHow this folder works.\n");

    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides).toEqual([]);
    expect(result.problems).toEqual([]);
  });

  it("reports a Markdown file that is not a guide rather than ignoring it", async () => {
    await writeDocument("draft.md", "# Draft\n\nStill thinking.\n");

    const result = await readPublicGuides(repositoryRoot);

    expect(result.guides).toEqual([]);
    expect(result.problems).toHaveLength(1);
    expect(result.problems[0]?.sourcePath).toBe(join(publicDocumentationDirectory, "draft.md"));
  });

  it("reports an id claimed by two documents, naming both", async () => {
    await writeDocument("one.md", guide("live-data"));
    await writeDocument("two.md", guide("live-data"));

    const result = await readPublicGuides(repositoryRoot);

    expect(result.problems).toHaveLength(2);
    for (const problem of result.problems) {
      expect(problem.reason).toContain("live-data");
    }
  });
});
