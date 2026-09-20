#!/usr/bin/env node

/**
 * Writes the files derived from the configuration inventory, or checks them.
 *
 * `.env.example` and the private secret ownership document both restate what
 * `packages/config/src/inventory.ts` already knows. Restating by hand is how a
 * variable ends up documented with a default it no longer has, so neither file
 * is written by a person. With `--check` the same code compares instead of
 * writing, which is what CI runs: one code path produces both the file and the
 * verdict, so they cannot disagree.
 *
 * Usage:
 *   node scripts/sync-config-files.mjs
 *   node scripts/sync-config-files.mjs --check
 */

import { mkdir, readFile, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { renderEnvExample, renderSecretOwnership } from "@playable/config";

const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));
const checkOnly = process.argv.includes("--check");

/**
 * The generated files, each with where it goes and whether it is committed.
 *
 * The private document is not checked, because it is not in the repository for
 * a check to compare against. It is regenerated on every sync so that the copy
 * on this machine is never older than the inventory.
 */
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
];

const stale = [];

for (const file of generatedFiles) {
  const absolutePath = join(repositoryRoot, file.path);
  const expected = file.render();

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

if (stale.length > 0) {
  console.error("Generated configuration files no longer match the inventory.\n");
  for (const path of stale) {
    console.error(`  ${path}`);
  }
  console.error('\nRun "pnpm config:sync" and commit the result.');
  process.exit(1);
}

if (checkOnly) console.log("Generated configuration files match the inventory.");
