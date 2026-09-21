#!/usr/bin/env node

/**
 * Checks the deployment definition against its schema and against the code.
 *
 * Three things have to agree about which services exist: `PlayableService` in
 * `@playable/contracts`, the topology in `zerops-project-import.yml` and the
 * pipelines in `zerops.yml`. A hostname is an address inside the project, so a
 * service named in one place and not another is not a typo with a warning: it
 * is a service nothing can reach, and the first sign of it is a deployment
 * that starts and then answers nothing.
 *
 * Schema validation covers `zerops.yml` only, because Zerops publishes a
 * schema for it and none for the import file. The cross-checks below are what
 * cover the import file.
 */

import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { administrativeDatabaseUrlName, entriesForService } from "@playable/config";
import { PlayableService, playableServiceNames } from "@playable/contracts";
import Ajv2020 from "ajv/dist/2020.js";
import { parse } from "yaml";

const repositoryRoot = fileURLToPath(new URL("..", import.meta.url));

/** The service that is a database rather than something built from this repository. */
const databaseService = PlayableService.Database;

const problems = [];

/**
 * Reads and parses a YAML file from the repository root.
 *
 * @param relativePath - Path relative to the repository root.
 * @returns The parsed document.
 */
async function readYaml(relativePath) {
  return parse(await readFile(join(repositoryRoot, relativePath), "utf8"));
}

const [schema, projectImport, pipelines] = await Promise.all([
  readFile(join(repositoryRoot, "scripts/schemas/zerops-yml.schema.json"), "utf8").then(JSON.parse),
  readYaml("zerops-project-import.yml"),
  readYaml("zerops.yml"),
]);

// 1. zerops.yml against the schema Zerops publishes for it.
// The schema declares draft 2020-12, which ajv's default export does not
// understand. Using the wrong entry point throws rather than mis-validating,
// which is the failure mode to prefer.
const validate = new Ajv2020({ allErrors: true, strict: false }).compile(schema);
if (!validate(pipelines)) {
  for (const error of validate.errors ?? []) {
    problems.push(`zerops.yml${error.instancePath} ${error.message}`);
  }
}

const importedHostnames = (projectImport.services ?? []).map((service) => service.hostname);
const pipelineNames = (pipelines.zerops ?? []).map((service) => service.setup);

// 2. Every hostname is a service the code knows by that exact name.
for (const hostname of importedHostnames) {
  if (!playableServiceNames.includes(hostname)) {
    problems.push(
      `zerops-project-import.yml declares the service "${hostname}", which is not a member of PlayableService`,
    );
  }
}

// 3. Every service built from this repository has both a topology entry and a
//    pipeline. The database has no pipeline, because nothing here builds it.
for (const service of playableServiceNames) {
  if (!importedHostnames.includes(service)) {
    problems.push(`${service} is a PlayableService with no entry in zerops-project-import.yml`);
  }

  if (service !== databaseService && !pipelineNames.includes(service)) {
    problems.push(`${service} is a PlayableService with no pipeline in zerops.yml`);
  }
}

for (const name of pipelineNames) {
  if (!importedHostnames.includes(name)) {
    problems.push(`zerops.yml builds "${name}", which no service in zerops-project-import.yml provides`);
  }
}

if (pipelineNames.includes(databaseService)) {
  problems.push(`zerops.yml builds "${databaseService}", which Zerops provides and this repository does not`);
}

// 4. The administrative connection appears nowhere. Any service refuses to
//    start while it is set, so a deployment carrying it would never come up,
//    and the reason would be invisible in the deployment log.
for (const [file, document] of [
  ["zerops-project-import.yml", projectImport],
  ["zerops.yml", pipelines],
]) {
  if (JSON.stringify(document).includes(administrativeDatabaseUrlName)) {
    problems.push(`${file} mentions ${administrativeDatabaseUrlName}, which no deployment may carry`);
  }
}

// 5. Every required variable is either set in the pipeline or supplied as a
//    secret by the topology. A service missing one starts, fails its own
//    configuration check and restarts, which reads as a crash loop rather than
//    as a missing variable.
for (const service of pipelines.zerops ?? []) {
  if (!playableServiceNames.includes(service.setup)) continue;

  const fromPipeline = Object.keys(service.run?.envVariables ?? {});
  const fromSecrets = Object.keys(
    (projectImport.services ?? []).find((entry) => entry.hostname === service.setup)?.envSecrets ?? {},
  );
  const available = new Set([...fromPipeline, ...fromSecrets]);

  for (const entry of entriesForService(service.setup)) {
    if (entry.fallback === undefined && !available.has(entry.name)) {
      problems.push(`${service.setup} needs ${entry.name}, which neither its pipeline nor its secrets provide`);
    }
  }
}

if (problems.length > 0) {
  console.error("The deployment definition does not hold together.\n");
  for (const problem of problems) {
    console.error(`  ${problem}`);
  }
  process.exit(1);
}

console.log(
  `Deployment definition is consistent: ${importedHostnames.length} services, ${pipelineNames.length} pipelines.`,
);
