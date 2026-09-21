import { administrativeDatabaseUrlName, configurationInventory } from "@playable/config";
import { describe, expect, it } from "vitest";
import { isSecretFieldName, isSecretValue, REDACTED, redact } from "./redaction.js";

describe("isSecretFieldName", () => {
  it("covers every secret in the configuration inventory", () => {
    for (const entry of configurationInventory.filter((entry) => entry.secret)) {
      expect(isSecretFieldName(entry.name), `${entry.name} is not redacted`).toBe(true);
    }
  });

  it("covers the administrative connection", () => {
    expect(isSecretFieldName(administrativeDatabaseUrlName)).toBe(true);
  });

  it.each([
    "authorization",
    "Authorization",
    "authorizationHeader",
    "API_KEY",
    "apiKey",
    "set-cookie",
  ])("matches %s however it is spelled", (name) => {
    expect(isSecretFieldName(name)).toBe(true);
  });

  it.each(["route", "status", "podcastId", "durationMs"])("leaves %s alone", (name) => {
    expect(isSecretFieldName(name)).toBe(false);
  });
});

describe("isSecretValue", () => {
  it("matches a connection string carrying a password", () => {
    expect(isSecretValue("postgresql://playable:hunter2@db.example.com:5432/playable")).toBe(true);
  });

  it("matches an authorization header value", () => {
    expect(isSecretValue("Bearer abcdef0123456789")).toBe(true);
  });

  it("matches a JSON Web Token", () => {
    expect(isSecretValue("eyJhbGciOi.eyJzdWIiOi.SflKxwRJSM")).toBe(true);
  });

  it("leaves an ordinary URL alone", () => {
    expect(isSecretValue("https://playable.at/live")).toBe(false);
  });
});

describe("redact", () => {
  it("replaces a value under a secret field name", () => {
    expect(redact({ DATABASE_URL: "postgresql://a:b@c/d" })).toEqual({ DATABASE_URL: REDACTED });
  });

  it("replaces a credential that arrives under an innocent field name", () => {
    expect(redact({ detail: "could not connect to postgresql://playable:hunter2@db:5432/playable" })).toEqual({
      detail: REDACTED,
    });
  });

  it("keeps everything that is not a credential", () => {
    expect(redact({ route: "GET /live", status: 503, attempts: 2 })).toEqual({
      route: "GET /live",
      status: 503,
      attempts: 2,
    });
  });

  it("walks into nested objects and arrays", () => {
    const redacted = redact({ upstream: { headers: [{ authorization: "Bearer abcdef0123456789" }] } });

    expect(redacted).toEqual({ upstream: { headers: [{ authorization: REDACTED }] } });
  });

  it("reduces an error to its name, message and cause", () => {
    const error = new Error("connect failed", { cause: new Error("postgresql://a:secret@db/playable") });

    expect(redact(error)).toEqual({
      name: "Error",
      message: "connect failed",
      cause: { name: "Error", message: REDACTED },
    });
  });

  it("does not modify what it was given", () => {
    const original = { DATABASE_URL: "postgresql://a:b@c/d" };

    redact(original);

    expect(original.DATABASE_URL).toBe("postgresql://a:b@c/d");
  });

  it("survives a cycle", () => {
    const value: Record<string, unknown> = { route: "GET /live" };
    value.self = value;

    expect(redact(value)).toEqual({ route: "GET /live", self: "[circular]" });
  });

  it("stops before walking an unbounded structure", () => {
    let deep: Record<string, unknown> = { leaf: true };
    for (let level = 0; level < 12; level += 1) {
      deep = { next: deep };
    }

    expect(JSON.stringify(redact(deep))).toContain("[depth limit]");
  });
});
