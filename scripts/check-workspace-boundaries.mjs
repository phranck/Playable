#!/usr/bin/env node

/**
 * Fails when a workspace dependency points the wrong way or at nothing.
 *
 * Playable's dependency direction runs one way only: an application under
 * `apps/` may build on a package under `packages/`, and a package never builds
 * on an application. A package that reaches back into an application cannot be
 * reused by the next one and drags a whole service into every build that needs
 * one helper. pnpm resolves such a dependency happily, so nothing else reports
 * it.
 *
 * The second check catches a `workspace:*` dependency whose target does not
 * exist. `pnpm install` fails on it, but only after a lockfile has been written
 * on somebody's machine, and the message names the specifier rather than the
 * workspace that asked for it.
 */

import { readdir, readFile } from "node:fs/promises";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));

/** Where workspaces live, and whether other workspaces may depend on them. */
const workspaceRoots = [
  { directory: "apps", mayBeDependedOn: false },
  { directory: "packages", mayBeDependedOn: true },
];

/** The dependency fields a workspace reference can appear in. */
const dependencyFields = ["dependencies", "devDependencies", "peerDependencies", "optionalDependencies"];

/**
 * Reads every workspace that carries a `package.json`.
 *
 * A directory without one is not a workspace. `apps/desktop` is the case that
 * matters here: it is a SwiftPM package and pnpm never sees it.
 *
 * @returns One entry per workspace, holding its name, its root and whether
 *   other workspaces are allowed to depend on it.
 */
async function readWorkspaces() {
  const workspaces = [];

  for (const { directory, mayBeDependedOn } of workspaceRoots) {
    const absoluteRoot = join(repositoryRoot, directory);
    const entries = await readdir(absoluteRoot, { withFileTypes: true });

    for (const entry of entries) {
      if (!entry.isDirectory()) continue;

      const manifestPath = join(absoluteRoot, entry.name, "package.json");
      let manifest;
      try {
        manifest = JSON.parse(await readFile(manifestPath, "utf8"));
      } catch (error) {
        if (error.code === "ENOENT") continue;
        throw error;
      }

      workspaces.push({
        name: manifest.name,
        manifestPath: relative(repositoryRoot, manifestPath),
        mayBeDependedOn,
        dependencies: dependencyFields.flatMap((field) => Object.entries(manifest[field] ?? {})),
      });
    }
  }

  return workspaces;
}

const workspaces = await readWorkspaces();
const byName = new Map(workspaces.map((workspace) => [workspace.name, workspace]));
const problems = [];

for (const workspace of workspaces) {
  for (const [dependencyName, specifier] of workspace.dependencies) {
    if (!specifier.startsWith("workspace:")) continue;

    const dependency = byName.get(dependencyName);

    if (!dependency) {
      problems.push(
        `${workspace.manifestPath} depends on ${dependencyName}, which is not a workspace in this repository`,
      );
      continue;
    }

    if (!dependency.mayBeDependedOn) {
      problems.push(
        `${workspace.manifestPath} depends on ${dependencyName}, and an application may not be depended on`,
      );
    }
  }
}

if (problems.length > 0) {
  console.error("Workspace dependency direction is violated.\n");
  for (const problem of problems) {
    console.error(`  ${problem}`);
  }
  console.error("\nApplications build on packages. Move shared code into a package under packages/.");
  process.exit(1);
}

console.log(`Dependency direction holds across ${workspaces.length} workspaces.`);
