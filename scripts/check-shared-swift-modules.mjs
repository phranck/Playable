#!/usr/bin/env node

/**
 * Fails when a shared Swift module imports a user interface framework.
 *
 * PAP-PLY-001 decides that `PlayableCore`, `PlayableAPI` and `PlayableStore`
 * are shared by the macOS app and the later Linux app, and that neither app's
 * toolkit may reach into them. A single `import SwiftUI` in a shared module
 * compiles on macOS and turns the Linux work of Epic 10 from a second front end
 * into a port, so the failure has to surface on the machine that can still
 * build it. SwiftPM cannot express this, because a target's dependency list
 * covers other targets rather than the system frameworks it may import.
 */

import { readdir, readFile } from "node:fs/promises";
import { join, relative } from "node:path";
import { fileURLToPath } from "node:url";

const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));
const sharedModuleRoot = join(repositoryRoot, "apps/desktop/Sources");

/** The modules both desktop apps build on, so neither app's toolkit belongs in them. */
const sharedModules = ["PlayableCore", "PlayableAPI", "PlayableStore"];

/** Frameworks that bind a module to one desktop toolkit or one operating system. */
const forbiddenImports = [
  "SwiftUI",
  "AppKit",
  "UIKit",
  "Cocoa",
  "Carbon",
  "MediaPlayer",
  "AVKit",
  "Adwaita",
  "Gtk4",
  "Gtk",
  "CGtk",
  "CAdw",
  "Gdk",
  "GLib",
];

const importPattern = new RegExp(`^\\s*(?:@[A-Za-z]+\\s+)*import\\s+(${forbiddenImports.join("|")})\\b`);

/**
 * Lists every Swift file below a directory.
 *
 * @param directory - Absolute path to search.
 * @returns Absolute paths of all `.swift` files found, at any depth.
 */
async function swiftFilesIn(directory) {
  const entries = await readdir(directory, { withFileTypes: true, recursive: true });
  return entries
    .filter((entry) => entry.isFile() && entry.name.endsWith(".swift"))
    .map((entry) => join(entry.parentPath, entry.name));
}

/**
 * Collects every forbidden import in one module.
 *
 * @param moduleName - Name of the shared module, matching its Sources directory.
 * @returns One finding per offending line, each naming file, line and framework.
 */
async function findingsFor(moduleName) {
  const moduleDirectory = join(sharedModuleRoot, moduleName);
  const files = await swiftFilesIn(moduleDirectory);
  const findings = [];

  for (const file of files) {
    const contents = await readFile(file, "utf8");

    contents.split("\n").forEach((line, index) => {
      const match = line.match(importPattern);
      if (match) {
        findings.push({
          file: relative(repositoryRoot, file),
          line: index + 1,
          framework: match[1],
        });
      }
    });
  }

  return findings;
}

const findings = (await Promise.all(sharedModules.map(findingsFor))).flat();

if (findings.length > 0) {
  console.error("Shared Swift modules must not import a user interface framework.\n");
  for (const finding of findings) {
    console.error(`  ${finding.file}:${finding.line} imports ${finding.framework}`);
  }
  console.error("\nMove the code that needs this framework into the platform layer of the app that owns it.");
  process.exit(1);
}

console.log(`No user interface framework imported by ${sharedModules.join(", ")}.`);
