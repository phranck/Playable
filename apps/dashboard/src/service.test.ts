import { isPlayableServiceName, PlayableService } from "@playable/contracts";
import { describe, expect, it } from "vitest";
import { serviceName } from "./service.js";

describe("serviceName", () => {
  it("names this workspace as the dashboard service", () => {
    expect(serviceName).toBe(PlayableService.Dashboard);
  });

  it("is a canonical Playable service name", () => {
    expect(isPlayableServiceName(serviceName)).toBe(true);
  });
});
