import { describe, expect, it } from "vitest";
import {
  databaseName,
  databaseRole,
  localDatabaseImage,
  localDatabasePort,
  localDatabaseUrl,
  postgresMajorVersion,
  zeropsDatabaseServiceType,
} from "./database.js";
import { configurationInventory } from "./inventory.js";

describe("the database pin", () => {
  it("names one major version everywhere it appears", () => {
    expect(zeropsDatabaseServiceType).toContain(postgresMajorVersion);
    expect(localDatabaseImage).toContain(postgresMajorVersion);
  });

  it("asks Zerops for a single container rather than a cluster", () => {
    expect(zeropsDatabaseServiceType).toBe(`postgresql:single@${postgresMajorVersion}`);
  });

  it("keeps off the ports the other projects on this machine use", () => {
    // lmaa holds 5432, musiccloud 5433 and layered-postgres 5434. A connection
    // to one of those succeeds and answers every query about the wrong data.
    expect(localDatabasePort).toBeGreaterThan(5434);
  });
});

describe("localDatabaseUrl", () => {
  it("addresses this machine", () => {
    expect(new URL(localDatabaseUrl).hostname).toBe("127.0.0.1");
  });

  it("uses the pinned port, role and database", () => {
    const url = new URL(localDatabaseUrl);

    expect(url.port).toBe(String(localDatabasePort));
    expect(url.username).toBe(databaseRole);
    expect(url.pathname).toBe(`/${databaseName}`);
  });

  it("is what .env.example offers for DATABASE_URL", () => {
    const entry = configurationInventory.find((candidate) => candidate.name === "DATABASE_URL");

    expect(entry?.example).toBe(localDatabaseUrl);
  });

  it("is what .env.example offers for DB_MIGRATION_ROLE", () => {
    const entry = configurationInventory.find((candidate) => candidate.name === "DB_MIGRATION_ROLE");

    expect(entry?.example).toBe(databaseRole);
  });
});
