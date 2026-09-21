import { describe, expect, it } from "vitest";
import { backupPolicy, runbookPlaceholders, runbookProcedures } from "./operations.js";
import { isSecretValue } from "./redaction.js";
import { renderOperationsRunbook } from "./runbook.js";

const runbook = renderOperationsRunbook();

describe("runbookProcedures", () => {
  it("gives every procedure a name, a trigger and at least one step", () => {
    for (const procedure of runbookProcedures) {
      expect(procedure.title).toBeTruthy();
      expect(procedure.when, `${procedure.title} does not say when to use it`).toBeTruthy();
      expect(procedure.steps.length, `${procedure.title} has no steps`).toBeGreaterThan(0);
    }
  });

  it("names each procedure once", () => {
    const titles = runbookProcedures.map((procedure) => procedure.title);

    expect(new Set(titles).size).toBe(titles.length);
  });

  it("holds no credential, because the repository is public", () => {
    const everything = JSON.stringify([runbookProcedures, backupPolicy, runbookPlaceholders]);

    expect(isSecretValue(everything)).toBe(false);
  });
});

describe("renderOperationsRunbook", () => {
  it("says it is generated and where to change it", () => {
    expect(runbook).toContain("packages/observability/src/operations.ts");
    expect(runbook).toContain("pnpm generate");
  });

  it("includes every procedure and every step", () => {
    for (const procedure of runbookProcedures) {
      expect(runbook).toContain(procedure.title);
      for (const step of procedure.steps) {
        expect(runbook).toContain(step.action);
      }
    }
  });

  it("states the backup schedule and retention", () => {
    expect(runbook).toContain(backupPolicy.schedule);
    expect(runbook).toContain(backupPolicy.retention);
  });

  it("lists what an operator has to fill in", () => {
    for (const placeholder of runbookPlaceholders) {
      expect(runbook).toContain(placeholder.label);
    }
  });

  it("ends in a newline", () => {
    expect(runbook.endsWith("\n")).toBe(true);
  });
});
