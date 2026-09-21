#!/usr/bin/env node

/**
 * Writes every file derived from something else in the repository, or checks it.
 *
 * `.env.example`, the secret ownership record and the operations runbook all
 * restate what a source module already knows. Restating by hand is how a
 * variable ends up documented with a default it no longer has, so none of them
 * is written by a person. With `--check` the same code compares instead of
 * writing, which is what CI runs: one code path produces both the file and the
 * verdict, so the two cannot disagree.
 *
 * Only committed files are checked. A file rendered into
 * `Documentations/private/` is not in the repository for a check to compare
 * against, so it is rewritten on every run instead, which keeps the copy on
 * this machine from being older than its source.
 *
 * Usage:
 *   node scripts/sync-generated-files.mjs
 *   node scripts/sync-generated-files.mjs --check
 */

import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { renderEnvExample, renderSecretOwnership } from "@playable/config";
import { renderOperationsRunbook } from "@playable/observability";

const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));
const checkOnly = process.argv.includes("--check");

/** The generated files, each with where it goes and whether it is committed. */
const generatedFiles = [
  {
    path: ".env.example",
    render: renderEnvExample,
    committed: true,
  },
  {
    path: "Documentations/private/secret-ownership.md",
    render: renderSecretOwnership,
    committed: false,
  },
  {
    path: "Documentations/private/operations-runbook.md",
    render: renderOperationsRunbook,
    committed: false,
  },
];

/**
 * The command that produces these files.
 *
 * Every rendered file names it, so a reader who found a wrong value in one
 * knows where to change it. The renderers live in different packages and each
 * writes the name itself, so the check below is what stops them drifting apart
 * when the script is renamed.
 */
const generateCommand = "pnpm generate";

const stale = [];
const missingCommand = [];

for (const file of generatedFiles) {
  const absolutePath = join(repositoryRoot, file.path);
  const expected = file.render();

  if (!expected.includes(generateCommand)) {
    missingCommand.push(file.path);
  }

  if (checkOnly && file.committed) {
    const actual = await readFile(absolutePath, "utf8").catch(() => undefined);
    if (actual !== expected) stale.push(file.path);
    continue;
  }

  if (checkOnly) continue;

  await mkdir(dirname(absolutePath), { recursive: true });
  await writeFile(absolutePath, expected, "utf8");
  console.log(`Wrote ${file.path}`);
}

if (missingCommand.length > 0) {
  console.error(`Every generated file must tell its reader to run "${generateCommand}".\n`);
  for (const path of missingCommand) {
    console.error(`  ${path} does not name it`);
  }
  console.error("\nThe renderer that produced it still names an older command.");
  process.exit(1);
}

if (stale.length > 0) {
  console.error("Generated files no longer match their source.\n");
  for (const path of stale) {
    console.error(`  ${path}`);
  }
  console.error('\nRun "pnpm generate" and commit the result.');
  process.exit(1);
}

if (checkOnly) console.log(`${generatedFiles.length} generated file(s) match their source.`);
