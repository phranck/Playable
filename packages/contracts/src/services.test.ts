import { describe, expect, it } from "vitest";
import { isPlayableServiceName, PlayableService, playableServiceNames } from "./services.js";

describe("playableServiceNames", () => {
  it("lists every member of the service namespace", () => {
    expect([...playableServiceNames].sort()).toEqual([...Object.values(PlayableService)].sort());
  });

  it("holds no duplicate wire name", () => {
    expect(new Set(playableServiceNames).size).toBe(playableServiceNames.length);
  });
});

describe("isPlayableServiceName", () => {
  it("accepts every canonical name", () => {
    for (const name of playableServiceNames) {
      expect(isPlayableServiceName(name)).toBe(true);
    }
  });

  it("rejects a name that no service carries", () => {
    expect(isPlayableServiceName("workers")).toBe(false);
  });

  it("rejects values that are not strings", () => {
    expect(isPlayableServiceName(undefined)).toBe(false);
    expect(isPlayableServiceName(42)).toBe(false);
  });
});
