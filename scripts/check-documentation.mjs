#!/usr/bin/env node

/**
 * Fails when a public guide is unusable or a private document is tracked.
 *
 * Two rules, one check. A public guide that the documentation build silently
 * drops is invisible until somebody goes looking for a page that was never
 * there, and a private document that reaches the remote repository cannot be
 * taken back by deleting it. Both are cheap to catch here and expensive to
 * notice later.
 *
 * The parsing lives in `@playable/docs` rather than in this file, because the
 * documentation build reads the same documents. Two readers would eventually
 * disagree about what a valid guide is, and the published site would be the
 * one that decided.
 */

import { execFile } from "node:child_process";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";
import { privateDocumentationDirectory, publicDocumentationDirectory, readPublicGuides } from "@playable/docs";

const run = promisify(execFile);
const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));

/**
 * Lists the files Git tracks below the private documentation directory.
 *
 * `.gitignore` stops them being added by accident, and this catches the case it
 * cannot: a file added before the rule existed, or one forced in with `git add
 * -f`. Git keeps tracking such a file and never mentions it again.
 *
 * @returns Repository-relative paths, empty when the rule holds.
 */
async function trackedPrivateDocuments() {
  const privatePath = `${publicDocumentationDirectory}/${privateDocumentationDirectory}`;
  const { stdout } = await run("git", ["ls-files", "--", privatePath], { cwd: repositoryRoot });
  return stdout.split("\n").filter((line) => line !== "");
}

const [{ guides, problems }, trackedPrivate] = await Promise.all([
  readPublicGuides(repositoryRoot),
  trackedPrivateDocuments(),
]);

let failed = false;

if (trackedPrivate.length > 0) {
  failed = true;
  console.error(`Private documents must not be tracked by Git.\n`);
  for (const path of trackedPrivate) {
    console.error(`  ${path}`);
  }
  console.error(`\nRemove them with "git rm --cached <path>". They stay on disk and stay out of the repository.\n`);
}

if (problems.length > 0) {
  failed = true;
  console.error("Public documents must be usable guides.\n");
  for (const problem of problems) {
    console.error(`  ${problem.sourcePath}: ${problem.reason}`);
  }
  console.error(`\nSee ${publicDocumentationDirectory}/README.md for the front matter a guide declares.\n`);
}

if (failed) process.exit(1);

console.log(`${guides.length} public guide(s) ready, no private document tracked.`);
