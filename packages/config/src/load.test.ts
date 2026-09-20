import { PlayableService } from "@playable/contracts";
import { describe, expect, it } from "vitest";
import { PlayableEnvironment } from "./environments.js";
import { administrativeDatabaseUrlName } from "./inventory.js";
import { ConfigurationError, loadServiceConfiguration } from "./load.js";

/** A local backend environment with nothing missing. */
function validBackendEnvironment(overrides: Record<string, string> = {}): NodeJS.ProcessEnv {
  return {
    PLAYABLE_ENVIRONMENT: PlayableEnvironment.Local,
    DATABASE_URL: "postgresql://playable:password@127.0.0.1:5432/playable",
    DB_MIGRATION_ROLE: "playable",
    ...overrides,
  };
}

describe("loadServiceConfiguration", () => {
  it("fills every optional variable from its fallback", () => {
    const configuration = loadServiceConfiguration(PlayableService.Backend, validBackendEnvironment());

    expect(configuration.environment).toBe(PlayableEnvironment.Local);
    expect(configuration.values.NODE_ENV).toBe("development");
    expect(configuration.values.PORT).toBe("4000");
  });

  it("prefers a value from the environment over the fallback", () => {
    const configuration = loadServiceConfiguration(PlayableService.Backend, validBackendEnvironment({ PORT: "4100" }));

    expect(configuration.values.PORT).toBe("4100");
  });

  it("treats an empty value as absent", () => {
    const configuration = loadServiceConfiguration(PlayableService.Backend, validBackendEnvironment({ PORT: "" }));

    expect(configuration.values.PORT).toBe("4000");
  });

  it("names every missing required variable in one error", () => {
    try {
      loadServiceConfiguration(PlayableService.Backend, { PLAYABLE_ENVIRONMENT: PlayableEnvironment.Local });
      expect.unreachable("An incomplete environment must not configure a service");
    } catch (error) {
      expect(error).toBeInstanceOf(ConfigurationError);
      const problems = (error as ConfigurationError).problems;
      expect(problems).toHaveLength(2);
      expect(problems.join("\n")).toContain("DATABASE_URL");
      expect(problems.join("\n")).toContain("DB_MIGRATION_ROLE");
    }
  });

  it("says what a missing variable is for", () => {
    try {
      loadServiceConfiguration(PlayableService.Backend, { PLAYABLE_ENVIRONMENT: PlayableEnvironment.Local });
      expect.unreachable("An incomplete environment must not configure a service");
    } catch (error) {
      expect((error as ConfigurationError).message).toContain("migrations must run as");
    }
  });

  it("rejects a value outside a closed set", () => {
    try {
      loadServiceConfiguration(PlayableService.Backend, validBackendEnvironment({ PLAYABLE_ENVIRONMENT: "prod" }));
      expect.unreachable("An unknown environment name must not configure a service");
    } catch (error) {
      expect((error as ConfigurationError).problems.join("\n")).toContain("local, preview, staging, production");
    }
  });

  it("rejects a remote database in a development environment", () => {
    try {
      loadServiceConfiguration(
        PlayableService.Backend,
        validBackendEnvironment({ DATABASE_URL: "postgresql://db:password@db.example.com:5432/playable" }),
      );
      expect.unreachable("A local run must not reach a remote database");
    } catch (error) {
      expect((error as ConfigurationError).problems.join("\n")).toContain("other than this machine");
    }
  });

  it("rejects a database URL it cannot parse", () => {
    try {
      loadServiceConfiguration(PlayableService.Backend, validBackendEnvironment({ DATABASE_URL: "not a url" }));
      expect.unreachable("An unparseable connection string must not be vouched for");
    } catch (error) {
      expect((error as ConfigurationError).problems.join("\n")).toContain("other than this machine");
    }
  });

  it.each(["localhost", "127.0.0.1", "[::1]"])("accepts the loopback host %s", (host) => {
    const configuration = loadServiceConfiguration(
      PlayableService.Backend,
      validBackendEnvironment({ DATABASE_URL: `postgresql://playable:password@${host}:5432/playable` }),
    );

    expect(configuration.values.DATABASE_URL).toContain(host);
  });

  it("refuses to start any service while the administrative connection is set", () => {
    try {
      loadServiceConfiguration(
        PlayableService.Backend,
        validBackendEnvironment({ [administrativeDatabaseUrlName]: "postgresql://admin:pw@127.0.0.1:5432/playable" }),
      );
      expect.unreachable("No service may start with the administrative connection set");
    } catch (error) {
      expect((error as ConfigurationError).problems.join("\n")).toContain(administrativeDatabaseUrlName);
    }
  });

  it("leaves a deployed environment to reach its own remote database", () => {
    const configuration = loadServiceConfiguration(
      PlayableService.Backend,
      validBackendEnvironment({
        PLAYABLE_ENVIRONMENT: PlayableEnvironment.Staging,
        NODE_ENV: "production",
        DATABASE_URL: "postgresql://playable:password@postgresql:5432/playable",
      }),
    );

    expect(configuration.environment).toBe(PlayableEnvironment.Staging);
  });

  it("gives a service only the variables it reads", () => {
    const configuration = loadServiceConfiguration(PlayableService.Website, {
      PLAYABLE_ENVIRONMENT: PlayableEnvironment.Local,
      BACKEND_URL: "http://127.0.0.1:4000",
      DATABASE_URL: "postgresql://playable:password@127.0.0.1:5432/playable",
    });

    expect(configuration.values.BACKEND_URL).toBe("http://127.0.0.1:4000");
    expect(configuration.values.DATABASE_URL).toBeUndefined();
  });
});
