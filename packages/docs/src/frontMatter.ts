/**
 * The keys a public guide declares about itself.
 *
 * The values live in the document rather than in a separate manifest, so a
 * guide that is renamed, moved or deleted carries its own metadata with it. A
 * manifest would be a second place to change, and the two would drift.
 */
export interface GuideFrontMatter {
  /** Stable anchor for the chapter, unique across all public guides. */
  id: string;
  /** Chapter heading shown in the content, the sidebar and search results. */
  title: string;
  /** Where the chapter sits relative to the generated API reference. */
  position: GuidePosition;
}

/**
 * Where a guide chapter sits in the generated documentation site.
 *
 * The three values are the ones the documentation generator accepts. Keeping
 * the set here rather than in the generator's configuration means a document
 * asking for an unsupported position fails the repository check rather than
 * the deployment build.
 */
export const GuidePosition = {
  /** Above the integration guide, for anything a reader needs first. */
  BeforeGuide: "before-guide",
  /** Between the integration guide and the endpoint reference. */
  AfterGuide: "after-guide",
  /** Below the schemas chapter, for appendices and downloads. */
  AfterReference: "after-reference",
} as const;

/** One of the positions in {@link GuidePosition}. */
export type GuidePosition = (typeof GuidePosition)[keyof typeof GuidePosition];

/** Every accepted position, used for validation and for error messages. */
export const guidePositions: readonly GuidePosition[] = Object.values(GuidePosition);

/** A front matter block that could not be read, with the reason why. */
export interface FrontMatterProblem {
  /** What is wrong, phrased so the author can act on it without reading this file. */
  reason: string;
}

/** The outcome of reading one document's front matter. */
export type FrontMatterResult =
  | { ok: true; frontMatter: GuideFrontMatter; body: string }
  | { ok: false; problems: FrontMatterProblem[] };

const FENCE = "---";

/**
 * Reads the front matter block at the top of a public guide.
 *
 * The accepted format is deliberately narrow: a `---` fence, one `key: value`
 * line per entry, then a closing `---`. It is not YAML, and anything a YAML
 * parser would accept beyond this shape is rejected. A permissive parser here
 * would let a typo through as a valid document with a surprising value, and the
 * surprise would surface as a missing chapter on a published site.
 *
 * @param contents - The complete text of the Markdown document.
 * @returns The parsed front matter and the body below it, or the list of
 *   problems that stopped it being read.
 */
export function readFrontMatter(contents: string): FrontMatterResult {
  const lines = contents.split("\n");

  if (lines[0]?.trim() !== FENCE) {
    return { ok: false, problems: [{ reason: `The document must start with a ${FENCE} front matter fence` }] };
  }

  const closingIndex = lines.findIndex((line, index) => index > 0 && line.trim() === FENCE);
  if (closingIndex === -1) {
    return { ok: false, problems: [{ reason: `The front matter block has no closing ${FENCE} fence` }] };
  }

  const problems: FrontMatterProblem[] = [];
  const entries = new Map<string, string>();

  for (let index = 1; index < closingIndex; index += 1) {
    const line = lines[index] ?? "";
    if (line.trim() === "") continue;

    const separatorIndex = line.indexOf(":");
    if (separatorIndex === -1) {
      problems.push({ reason: `Line ${index + 1} of the front matter is not a "key: value" pair` });
      continue;
    }

    const key = line.slice(0, separatorIndex).trim();
    const value = line.slice(separatorIndex + 1).trim();

    if (entries.has(key)) {
      problems.push({ reason: `The front matter declares "${key}" more than once` });
      continue;
    }

    entries.set(key, value);
  }

  const frontMatter = validate(entries, problems);
  const body = lines
    .slice(closingIndex + 1)
    .join("\n")
    .trim();

  if (!frontMatter || problems.length > 0) {
    return { ok: false, problems };
  }

  return { ok: true, frontMatter, body };
}

/**
 * Checks the collected entries against the required shape.
 *
 * Problems are appended rather than thrown so that one pass reports everything
 * wrong with a document. An author fixing one missing key at a time learns
 * about the next one only after another run.
 *
 * @param entries - The `key: value` pairs read from the block.
 * @param problems - Collector the caller also reads, appended to in place.
 * @returns The validated front matter, or `undefined` when something is wrong.
 */
function validate(entries: Map<string, string>, problems: FrontMatterProblem[]): GuideFrontMatter | undefined {
  const known = new Set(["id", "title", "position"]);
  for (const key of entries.keys()) {
    if (!known.has(key)) {
      problems.push({ reason: `The front matter declares "${key}", which is not one of id, title or position` });
    }
  }

  const id = entries.get("id");
  const title = entries.get("title");
  const position = entries.get("position");

  if (!id) problems.push({ reason: 'The front matter needs a non-empty "id"' });
  if (!title) problems.push({ reason: 'The front matter needs a non-empty "title"' });

  if (!position) {
    problems.push({ reason: 'The front matter needs a non-empty "position"' });
  } else if (!guidePositions.includes(position as GuidePosition)) {
    problems.push({
      reason: `The position "${position}" is not one of ${guidePositions.join(", ")}`,
    });
  }

  if (id && !/^[a-z0-9]+(-[a-z0-9]+)*$/.test(id)) {
    problems.push({ reason: `The id "${id}" must be lowercase words joined by single hyphens` });
  }

  if (!id || !title || !position || problems.length > 0) return undefined;

  return { id, title, position: position as GuidePosition };
}
