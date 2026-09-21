import { describe, expect, it } from "vitest";
import {
  ChannelState,
  channelStates,
  isChannelState,
  isOnAir,
  type LiveChannel,
  sortedForOverview,
} from "./liveChannel.js";

/** Builds a channel with only what a test cares about spelled out. */
function channel(overrides: Partial<LiveChannel> & Pick<LiveChannel, "id" | "name">): LiveChannel {
  return {
    state: ChannelState.Live,
    onAir: true,
    listenerCount: 0,
    ...overrides,
  };
}

describe("channelStates", () => {
  it("lists the seven names the legacy source maps, in its order", () => {
    expect(channelStates).toEqual(["preshow", "live", "postshow", "offline", "online", "break", "test"]);
  });
});

describe("isOnAir", () => {
  it.each([
    ChannelState.Preshow,
    ChannelState.Live,
    ChannelState.Postshow,
    ChannelState.Break,
    ChannelState.Test,
  ])("counts %s as on air", (state) => {
    expect(isOnAir(state)).toBe(true);
  });

  it("does not count offline as on air", () => {
    expect(isOnAir(ChannelState.Offline)).toBe(false);
  });

  it("does not count online as on air, despite the name", () => {
    expect(isOnAir(ChannelState.Online)).toBe(false);
  });

  it("does not count a state it has never heard of as on air", () => {
    expect(isOnAir("sleeping")).toBe(false);
    expect(isOnAir("")).toBe(false);
  });

  it("agrees with Podlive on every known state", () => {
    // Podlive's -isLive excludes undefined, offline and online, and nothing else.
    const onAir = channelStates.filter((state) => isOnAir(state));

    expect(onAir).toEqual(["preshow", "live", "postshow", "break", "test"]);
  });
});

describe("isChannelState", () => {
  it("accepts every known name", () => {
    for (const state of channelStates) {
      expect(isChannelState(state)).toBe(true);
    }
  });

  it("rejects anything else", () => {
    expect(isChannelState("sleeping")).toBe(false);
    expect(isChannelState(undefined)).toBe(false);
    expect(isChannelState(1)).toBe(false);
  });
});

describe("sortedForOverview", () => {
  it("puts the busiest first", () => {
    const sorted = sortedForOverview([
      channel({ id: "a", name: "Quiet", listenerCount: 3 }),
      channel({ id: "b", name: "Busy", listenerCount: 40 }),
    ]);

    expect(sorted.map((entry) => entry.id)).toEqual(["b", "a"]);
  });

  it("orders equal counts by name, so two requests agree", () => {
    const sorted = sortedForOverview([
      channel({ id: "z", name: "Zulu", listenerCount: 5 }),
      channel({ id: "a", name: "Alpha", listenerCount: 5 }),
    ]);

    expect(sorted.map((entry) => entry.id)).toEqual(["a", "z"]);
  });

  it("does not modify what it was given", () => {
    const channels = [
      channel({ id: "a", name: "Quiet", listenerCount: 3 }),
      channel({ id: "b", name: "Busy", listenerCount: 40 }),
    ];

    sortedForOverview(channels);

    expect(channels.map((entry) => entry.id)).toEqual(["a", "b"]);
  });
});
