import { entriesForService, loadServiceConfiguration } from "@playable/config";
import { describe, expect, it } from "vitest";
import { serviceName } from "./service.js";

describe("dashboard configuration", () => {
  it("needs nothing to be supplied, because it ships as static files", () => {
    const required = entriesForService(serviceName).filter((entry) => entry.fallback === undefined);

    expect(required).toEqual([]);
  });

  it("never asks for the database connection or the address of the backend", () => {
    const configuration = loadServiceConfiguration(serviceName, {
      PLAYABLE_ENVIRONMENT: "local",
      BACKEND_URL: "http://127.0.0.1:4000",
      DATABASE_URL: "postgresql://playable:password@127.0.0.1:5432/playable",
    });

    expect(configuration.values.DATABASE_URL).toBeUndefined();
    expect(configuration.values.BACKEND_URL).toBeUndefined();
  });
});
