import { ChannelState, type LiveChannel } from "@playable/contracts";
import type { ChannelSource } from "./channelSource.js";
import { parseChannelSource } from "./parseChannelSource.js";

/**
 * Channels for a machine that has no access to the legacy backend.
 *
 * They cover what the pages have to get right rather than what looks good in a
 * screenshot: a busy show, a quiet one, one in a state that counts as on air
 * despite its name, and one that is off.
 */
const fixtureChannels: readonly LiveChannel[] = [
  {
    id: "Ab3Cd5Ef7G",
    name: "Der Morgen",
    description: "Zwei Stunden über das, was gerade passiert.",
    state: ChannelState.Live,
    onAir: true,
    listenerCount: 128,
  },
  {
    id: "Hj9Kl2Mn4P",
    name: "Nachtschicht",
    description: "Gleich geht es los.",
    state: ChannelState.Preshow,
    onAir: true,
    listenerCount: 12,
  },
  {
    id: "Qr6St8Uv0W",
    name: "Werkstattgespräch",
    state: ChannelState.Break,
    onAir: true,
    listenerCount: 3,
  },
  {
    id: "Xy1Za3Bc5D",
    name: "Sonntagsrunde",
    description: "Jeden Sonntag um zehn.",
    state: ChannelState.Offline,
    onAir: false,
    listenerCount: 0,
  },
];

/** A source that answers from {@link fixtureChannels} and reaches nothing. */
export function fixtureChannelSource(): ChannelSource {
  return {
    async allChannels() {
      return [...fixtureChannels];
    },
    async channel(id) {
      return fixtureChannels.find((entry) => entry.id === id);
    },
  };
}

/**
 * The source the running site reads.
 *
 * Configured entirely from the environment, because the credentials belong to
 * the deployment rather than to this repository. A machine without them gets
 * the fixtures and says so in the log, which is what lets the site be built and
 * looked at without being given access to anything.
 *
 * @returns The source, chosen from what the environment supplies.
 */
export function channelSource(): ChannelSource {
  const serverUrl = process.env.PARSE_SERVER_URL;
  const applicationId = process.env.PARSE_APPLICATION_ID;
  const restApiKey = process.env.PARSE_REST_API_KEY;

  if (!serverUrl || !applicationId || !restApiKey) {
    // Only a developer's machine may fall back. A deployment that quietly
    // served fixtures would look entirely healthy whilst showing nobody who is
    // actually on air, and the first person to notice would be a listener.
    if (process.env.PLAYABLE_ENVIRONMENT !== "local" && process.env.PLAYABLE_ENVIRONMENT !== undefined) {
      throw new Error(
        "The legacy channel source is not configured. Set PARSE_SERVER_URL, PARSE_APPLICATION_ID and PARSE_REST_API_KEY.",
      );
    }

    console.warn(
      JSON.stringify({
        level: "warn",
        service: "website",
        message: "Serving fixture channels, because the legacy source is not configured.",
        operation: "channelSource",
        outcome: "fallback",
      }),
    );

    return fixtureChannelSource();
  }

  return parseChannelSource({ serverUrl, applicationId, restApiKey });
}
