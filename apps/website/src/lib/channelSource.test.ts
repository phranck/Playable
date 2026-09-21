import { ChannelState } from "@playable/contracts";
import { describe, expect, it } from "vitest";
import { channelFromLegacyRecord } from "./channelSource.js";

/** A record shaped the way the legacy source returns them. */
const record = {
  objectId: "Ab3Cd5Ef7G",
  name: "Der Morgen",
  description: "Zwei Stunden über das, was gerade passiert.",
  coverartThumbnail200: { __type: "File", url: "https://files.example/cover.png" },
  websiteUrl: "https://dermorgen.example",
  chatUrl: "https://chat.example/dermorgen",
  state: "live",
  listenerCount: 128,
  isEnabled: true,
  // Present in the legacy class and not in the public contract.
  email: "wer@example.com",
  creator: "Wer Auch Immer",
};

describe("channelFromLegacyRecord", () => {
  it("reads a complete record", () => {
    expect(channelFromLegacyRecord(record)).toEqual({
      id: "Ab3Cd5Ef7G",
      name: "Der Morgen",
      description: "Zwei Stunden über das, was gerade passiert.",
      coverUrl: "https://files.example/cover.png",
      websiteUrl: "https://dermorgen.example",
      chatUrl: "https://chat.example/dermorgen",
      state: ChannelState.Live,
      onAir: true,
      listenerCount: 128,
    });
  });

  it("never carries personal data into what is published", () => {
    const channel = channelFromLegacyRecord(record);

    expect(JSON.stringify(channel)).not.toContain("wer@example.com");
    expect(JSON.stringify(channel)).not.toContain("Wer Auch Immer");
  });

  it("treats a state it has never heard of as off air rather than guessing", () => {
    const channel = channelFromLegacyRecord({ ...record, state: "sleeping" });

    expect(channel?.state).toBe(ChannelState.Offline);
    expect(channel?.onAir).toBe(false);
  });

  it("counts a channel on a break as on air, the way Podlive does", () => {
    expect(channelFromLegacyRecord({ ...record, state: "break" })?.onAir).toBe(true);
  });

  it("does not count online as on air, despite the name", () => {
    expect(channelFromLegacyRecord({ ...record, state: "online" })?.onAir).toBe(false);
  });

  it("drops a record with no identifier or no name", () => {
    expect(channelFromLegacyRecord({ ...record, objectId: undefined })).toBeUndefined();
    expect(channelFromLegacyRecord({ ...record, name: "   " })).toBeUndefined();
  });

  it("drops a record switched off at the source", () => {
    expect(channelFromLegacyRecord({ ...record, isEnabled: false })).toBeUndefined();
  });

  it.each([
    "http://files.example/cover.png",
    "javascript:alert(1)",
    "not a url",
    "",
  ])("drops the address %s rather than rendering it", (url) => {
    const channel = channelFromLegacyRecord({ ...record, websiteUrl: url });

    expect(channel?.websiteUrl).toBeUndefined();
  });

  it("reads a cover given as a plain string as well as a file object", () => {
    expect(channelFromLegacyRecord({ ...record, coverartThumbnail200: "https://files.example/a.png" })?.coverUrl).toBe(
      "https://files.example/a.png",
    );
  });

  it("leaves out what the record does not carry", () => {
    const channel = channelFromLegacyRecord({ objectId: "Ab3Cd5Ef7G", name: "Ohne alles", state: "live" });

    expect(channel).toEqual({
      id: "Ab3Cd5Ef7G",
      name: "Ohne alles",
      state: ChannelState.Live,
      onAir: true,
      listenerCount: 0,
    });
  });

  it.each([undefined, -5, Number.NaN, "128"])("reads the listener count %s as nobody", (count) => {
    expect(channelFromLegacyRecord({ ...record, listenerCount: count })?.listenerCount).toBe(0);
  });
});
