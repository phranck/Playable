import { ConfigurationError, loadServiceConfiguration } from "@playable/config";
import { describe, expect, it } from "vitest";
import { serviceName } from "./service.js";

describe("dashboard configuration", () => {
  it("refuses to start without the address of the backend", () => {
    try {
      loadServiceConfiguration(serviceName, { PLAYABLE_ENVIRONMENT: "local" });
      expect.unreachable("The dashboard must not start unconfigured");
    } catch (error) {
      expect(error).toBeInstanceOf(ConfigurationError);
      expect((error as ConfigurationError).message).toContain("BACKEND_URL");
    }
  });

  it("never asks for the database connection", () => {
    const configuration = loadServiceConfiguration(serviceName, {
      PLAYABLE_ENVIRONMENT: "local",
      BACKEND_URL: "http://127.0.0.1:4000",
      DATABASE_URL: "postgresql://playable:password@127.0.0.1:5432/playable",
    });

    expect(configuration.values.DATABASE_URL).toBeUndefined();
  });
});
