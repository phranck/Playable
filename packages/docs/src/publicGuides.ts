import type { Dirent } from "node:fs";
import { readdir, readFile } from "node:fs/promises";
import { join, relative, sep } from "node:path";
import { type GuideFrontMatter, readFrontMatter } from "./frontMatter.js";

/**
 * One public technical guide, ready to be handed to the documentation site.
 *
 * The shape matches what the generator's custom sections take, so the build
 * passes these through rather than restating any of it. That is the whole point
 * of the front matter: the document is the single source, and the build is a
 * transport.
 */
export interface PublicGuide extends GuideFrontMatter {
  /** The document body below the front matter, as Markdown. */
  markdown: string;
  /** Path of the source document, relative to the repository root. */
  sourcePath: string;
}

/** A document that could not be used, with every reason found in one pass. */
export interface GuideProblem {
  /** Path of the source document, relative to the repository root. */
  sourcePath: string;
  /** What is wrong, phrased so the author can act on it. */
  reason: string;
}

/** Everything found below the public documentation directory. */
export interface PublicGuideSet {
  /** The usable guides, ordered by id so the result does not depend on the file system. */
  guides: PublicGuide[];
  /** Every reason a document was rejected. Empty means the set is usable. */
  problems: GuideProblem[];
}

/**
 * The directory holding public technical guides, relative to the repository root.
 *
 * Everything below it is published. The private subdirectory below is the one
 * exception and never leaves the machine it was written on.
 */
export const publicDocumentationDirectory = "Documentations";

/**
 * The subdirectory that stays local, relative to {@link publicDocumentationDirectory}.
 *
 * Named here as well as in `.gitignore` because a reader of this module has to
 * know which documents it deliberately skips, and because the repository check
 * uses the same constant when it verifies that nothing below it is tracked.
 */
export const privateDocumentationDirectory = "private";

/** Files inside the documentation directory that are not guides. */
const nonGuideFileNames = new Set(["README.md"]);

/**
 * Reads every public guide below the documentation directory.
 *
 * Documents below the private subdirectory are skipped, and every other
 * Markdown file is required to be a valid guide. A stray Markdown file without
 * front matter is reported as a problem rather than ignored, because a document
 * silently missing from a published site is the failure this whole arrangement
 * exists to prevent.
 *
 * @param repositoryRoot - Absolute path of the repository root.
 * @returns The usable guides and every problem found. The caller decides
 *   whether a problem is fatal, which lets the repository check report all of
 *   them at once whilst a build can stop at the first.
 */
export async function readPublicGuides(repositoryRoot: string): Promise<PublicGuideSet> {
  const documentationRoot = join(repositoryRoot, publicDocumentationDirectory);
  const guides: PublicGuide[] = [];
  const problems: GuideProblem[] = [];

  for (const file of await markdownFilesIn(documentationRoot)) {
    const sourcePath = relative(repositoryRoot, file);
    const result = readFrontMatter(await readFile(file, "utf8"));

    if (!result.ok) {
      for (const problem of result.problems) {
        problems.push({ sourcePath, reason: problem.reason });
      }
      continue;
    }

    guides.push({ ...result.frontMatter, markdown: result.body, sourcePath });
  }

  guides.sort((left, right) => left.id.localeCompare(right.id));
  problems.push(...duplicateIdProblems(guides));

  return { guides, problems };
}

/**
 * Lists the Markdown files that are meant to be guides.
 *
 * A missing documentation directory yields nothing rather than failing, because
 * a repository is allowed to have no public guides yet.
 */
async function markdownFilesIn(documentationRoot: string): Promise<string[]> {
  let entries: Dirent[];

  try {
    entries = await readdir(documentationRoot, { withFileTypes: true, recursive: true });
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") return [];
    throw error;
  }

  return entries
    .filter((entry) => entry.isFile() && entry.name.endsWith(".md"))
    .filter((entry) => !nonGuideFileNames.has(entry.name))
    .map((entry) => join(entry.parentPath, entry.name))
    .filter((file) => !isPrivate(file, documentationRoot));
}

/** Whether a file sits below the private subdirectory. */
function isPrivate(file: string, documentationRoot: string): boolean {
  const segments = relative(documentationRoot, file).split(sep);
  return segments[0] === privateDocumentationDirectory;
}

/**
 * Reports every id claimed by more than one document.
 *
 * The id becomes an in-page anchor, so a duplicate does not fail the
 * documentation build. It quietly produces two chapters competing for one
 * address, and the sidebar link reaches whichever the generator emitted last.
 */
function duplicateIdProblems(guides: readonly PublicGuide[]): GuideProblem[] {
  const pathsById = new Map<string, string[]>();

  for (const guide of guides) {
    pathsById.set(guide.id, [...(pathsById.get(guide.id) ?? []), guide.sourcePath]);
  }

  return [...pathsById.entries()]
    .filter(([, paths]) => paths.length > 1)
    .flatMap(([id, paths]) =>
      paths.map((sourcePath) => ({
        sourcePath,
        reason: `The id "${id}" is also claimed by ${paths.filter((other) => other !== sourcePath).join(", ")}`,
      })),
    );
}
