import { ConfigurationError, loadServiceConfiguration } from "@playable/config";
import { describe, expect, it } from "vitest";
import { serviceName } from "./service.js";

describe("backend configuration", () => {
  it("refuses to start without its database connection and migration role", () => {
    try {
      loadServiceConfiguration(serviceName, { PLAYABLE_ENVIRONMENT: "local" });
      expect.unreachable("The backend must not start unconfigured");
    } catch (error) {
      expect(error).toBeInstanceOf(ConfigurationError);
      const message = (error as ConfigurationError).message;
      expect(message).toContain("DATABASE_URL");
      expect(message).toContain("DB_MIGRATION_ROLE");
    }
  });

  it("starts from a complete local environment", () => {
    const configuration = loadServiceConfiguration(serviceName, {
      PLAYABLE_ENVIRONMENT: "local",
      DATABASE_URL: "postgresql://playable:password@127.0.0.1:5432/playable",
      DB_MIGRATION_ROLE: "playable",
    });

    expect(configuration.service).toBe(serviceName);
    expect(configuration.environment).toBe("local");
  });
});
