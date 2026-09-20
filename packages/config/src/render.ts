import { playableServiceNames } from "@playable/contracts";
import {
  administrativeDatabaseEntry,
  type ConfigurationEntry,
  configurationInventory,
  entriesForService,
} from "./inventory.js";

/**
 * The header both generated files carry.
 *
 * Written into the file rather than left to a reader's memory, because the
 * first instinct on finding a wrong value in a generated file is to correct it
 * there.
 */
function generatedHeader(command: string): string {
  return [
    "# Generated from the configuration inventory in packages/config.",
    "# Editing this file has no effect: the next run overwrites it.",
    `# Change packages/config/src/inventory.ts and run ${command}.`,
  ].join("\n");
}

/**
 * Renders the `.env.example` every developer copies to start.
 *
 * Secrets appear with their example value rather than a blank, so a fresh
 * checkout starts without a lookup. The examples are not credentials: the
 * database one addresses this machine, which is the only database a local run
 * is allowed to reach anyway.
 *
 * @returns The complete file contents, ending in a newline.
 */
export function renderEnvExample(): string {
  const lines = [generatedHeader("pnpm config:sync"), ""];

  for (const entry of configurationInventory) {
    lines.push(`# ${entry.purpose}`);
    lines.push(`# Read by: ${entry.services.join(", ")}`);
    if (entry.allowed) lines.push(`# One of: ${entry.allowed.join(", ")}`);
    lines.push(entry.fallback === undefined ? "# Required." : `# Optional, defaults to ${entry.fallback}.`);
    lines.push(`${entry.name}=${entry.example}`);
    lines.push("");
  }

  return lines.join("\n");
}

/**
 * Renders the private record of who owns each secret and when it is replaced.
 *
 * The document is generated into `Documentations/private/`, which never leaves
 * the machine. Nothing in it is a credential, only the names, the owners and
 * the cadence, but the shape of a system's secrets is a map of where to attack
 * it and belongs nowhere public.
 *
 * @returns The complete Markdown document, ending in a newline.
 */
export function renderSecretOwnership(): string {
  const secrets = [...configurationInventory.filter((entry) => entry.secret), administrativeDatabaseEntry];

  const lines = [
    "<!--",
    generatedHeader("pnpm config:sync").replace(/^# ?/gm, ""),
    "-->",
    "",
    "# Secret ownership and rotation",
    "",
    "This document stays on this machine. It holds no values, only which secrets exist, who holds the authoritative copy and when it is replaced.",
    "",
  ];

  for (const entry of secrets) {
    lines.push(`## ${entry.name}`);
    lines.push("");
    lines.push(entry.purpose);
    lines.push("");
    lines.push(`- **Read by:** ${entry.services.length > 0 ? entry.services.join(", ") : "no service, by design"}`);
    lines.push(`- **Owner:** ${entry.owner ?? "unrecorded"}`);
    lines.push(`- **Rotation:** ${entry.rotation ?? "unrecorded"}`);
    lines.push("");
  }

  lines.push("## What each service reads");
  lines.push("");
  lines.push("| Service | Required | Optional |");
  lines.push("|---|---|---|");

  for (const service of playableServiceNames) {
    const entries = entriesForService(service);
    if (entries.length === 0) continue;
    lines.push(`| ${service} | ${namesOf(entries, true)} | ${namesOf(entries, false)} |`);
  }

  lines.push("");

  return lines.join("\n");
}

/**
 * Lists the names of the entries that are required, or those that are not.
 *
 * @param entries - The entries one service reads.
 * @param required - `true` for entries without a fallback.
 * @returns A comma-separated list, or a dash when the set is empty.
 */
function namesOf(entries: readonly ConfigurationEntry[], required: boolean): string {
  const names = entries
    .filter((entry) => (entry.fallback === undefined) === required)
    .map((entry) => `\`${entry.name}\``);

  return names.length > 0 ? names.join(", ") : "none";
}
