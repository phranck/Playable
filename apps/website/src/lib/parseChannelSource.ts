import type { LiveChannel } from "@playable/contracts";
import { type ChannelSource, channelFromLegacyRecord } from "./channelSource.js";

/** What reaching the legacy source needs. All three are deployment secrets. */
export interface ParseSourceOptions {
  /** The Parse server's REST address, such as `https://example.com/parse`. */
  serverUrl: string;
  /** The application identifier the server expects. */
  applicationId: string;
  /** The read key. Never the master key: this site only reads. */
  restApiKey: string;
  /** How long a request may take before the page gives up on it. */
  timeoutMs?: number;
}

/** The legacy class and the one field the query is ordered by. */
const channelClassName = "Channel";

/**
 * How long a request may take.
 *
 * A page that waits indefinitely for a source is a page that never answers,
 * and an overview that cannot be built is still better than a request that
 * hangs until the reader leaves.
 */
const defaultTimeoutMs = 4_000;

/**
 * Reads channels from the legacy Parse backend.
 *
 * The credentials stay on the server. Nothing here runs in a browser, and the
 * page renders the result rather than the source, so a reader never learns
 * where the data came from or what opened it.
 *
 * @param options - The address and keys, supplied from deployment secrets.
 * @returns A source the pages can read.
 */
export function parseChannelSource(options: ParseSourceOptions): ChannelSource {
  const timeoutMs = options.timeoutMs ?? defaultTimeoutMs;

  /**
   * Runs one REST query and maps what comes back.
   *
   * @param query - The `where` clause, already an object.
   * @returns The channels that could be published.
   */
  async function fetchChannels(query: Record<string, unknown>): Promise<LiveChannel[]> {
    const url = new URL(`${options.serverUrl.replace(/\/$/, "")}/classes/${channelClassName}`);
    url.searchParams.set("where", JSON.stringify(query));
    url.searchParams.set("limit", "1000");

    const response = await fetch(url, {
      headers: {
        "X-Parse-Application-Id": options.applicationId,
        "X-Parse-REST-API-Key": options.restApiKey,
      },
      signal: AbortSignal.timeout(timeoutMs),
    });

    if (!response.ok) {
      // The status is enough to diagnose it and carries nothing secret. The
      // address and the keys deliberately stay out of the message.
      throw new Error(`The channel source answered ${response.status}.`);
    }

    const body = (await response.json()) as { results?: unknown };
    const results = Array.isArray(body.results) ? body.results : [];

    return results
      .map((record) => channelFromLegacyRecord(record as Record<string, unknown>))
      .filter((channel): channel is LiveChannel => channel !== undefined);
  }

  return {
    async allChannels() {
      return fetchChannels({ isEnabled: true });
    },

    async channel(id) {
      const [channel] = await fetchChannels({ objectId: id });
      return channel;
    },
  };
}
