import { isPlayableServiceName, PlayableService } from "@playable/contracts";
import { describe, expect, it } from "vitest";
import { serviceName } from "./service.js";

describe("serviceName", () => {
  it("names this workspace as the backend service", () => {
    expect(serviceName).toBe(PlayableService.Backend);
  });

  it("is a canonical Playable service name", () => {
    expect(isPlayableServiceName(serviceName)).toBe(true);
  });
});
