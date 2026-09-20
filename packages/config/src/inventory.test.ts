import { isPlayableServiceName, PlayableService } from "@playable/contracts";
import { describe, expect, it } from "vitest";
import { administrativeDatabaseEntry, configurationInventory, entriesForService } from "./inventory.js";

const secrets = configurationInventory.filter((entry) => entry.secret);

describe("configurationInventory", () => {
  it("names each variable once", () => {
    const names = configurationInventory.map((entry) => entry.name);

    expect(new Set(names).size).toBe(names.length);
  });

  it("names only real services", () => {
    for (const entry of configurationInventory) {
      for (const service of entry.services) {
        expect(isPlayableServiceName(service)).toBe(true);
      }
    }
  });

  it("gives every entry at least one reader", () => {
    for (const entry of configurationInventory) {
      expect(entry.services.length, `${entry.name} is read by nothing`).toBeGreaterThan(0);
    }
  });

  it("never gives a secret a fallback", () => {
    for (const entry of secrets) {
      expect(entry.fallback, `${entry.name} has a default value`).toBeUndefined();
    }
  });

  it("records an owner and a rotation for every secret", () => {
    for (const entry of [...secrets, administrativeDatabaseEntry]) {
      expect(entry.owner, `${entry.name} has no recorded owner`).toBeTruthy();
      expect(entry.rotation, `${entry.name} has no recorded rotation`).toBeTruthy();
    }
  });

  it("keeps an example inside its own accepted set", () => {
    for (const entry of configurationInventory) {
      if (!entry.allowed) continue;
      expect(entry.allowed, `${entry.name} has an example outside its accepted values`).toContain(entry.example);
    }
  });

  it("keeps the administrative connection out of the inventory", () => {
    const names = configurationInventory.map((entry) => entry.name);

    expect(names).not.toContain(administrativeDatabaseEntry.name);
    expect(administrativeDatabaseEntry.services).toEqual([]);
  });
});

describe("entriesForService", () => {
  it("returns only what that service reads", () => {
    const names = entriesForService(PlayableService.Website).map((entry) => entry.name);

    expect(names).toContain("BACKEND_URL");
    expect(names).not.toContain("DATABASE_URL");
  });

  it("keeps inventory order", () => {
    const entries = entriesForService(PlayableService.Backend);
    const positions = entries.map((entry) => configurationInventory.indexOf(entry));

    expect(positions).toEqual([...positions].sort((left, right) => left - right));
  });
});
