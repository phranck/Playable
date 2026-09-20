import { PlayableService, type PlayableServiceName } from "@playable/contracts";

/**
 * One configuration variable, described once for everything that needs to know.
 *
 * The loader validates against these entries, `.env.example` is generated from
 * them, and the private secret ownership document is generated from them. A
 * variable therefore exists in exactly one place, and the three consumers
 * cannot drift apart because none of them holds a copy.
 */
export interface ConfigurationEntry {
  /** The environment variable name, as the process sees it. */
  name: string;
  /** The services that read it. A variable no service reads does not belong here. */
  services: readonly PlayableServiceName[];
  /** What it is for, in one sentence, shown in `.env.example`. */
  purpose: string;
  /** Whether its value is a credential. Secrets are never given a default. */
  secret: boolean;
  /**
   * The value used when the variable is absent.
   *
   * `undefined` makes the variable required, so a service that reads it refuses
   * to start without it.
   */
  fallback?: string;
  /** An example value for `.env.example`, never a real credential. */
  example: string;
  /** The accepted values, when the variable is a closed set. */
  allowed?: readonly string[];
  /**
   * Who holds the authoritative value. Required for a secret.
   *
   * Not derivable from anything else, so it lives here and the private secret
   * document is generated from it rather than maintained beside it.
   */
  owner?: string;
  /** When the value is replaced. Required for a secret. */
  rotation?: string;
}

/**
 * Every configuration variable Playable reads today.
 *
 * The list grows with the features that need it. Authentication secrets, push
 * credentials and third-party keys are absent because nothing reads them yet,
 * and an inventory listing variables no code consumes teaches a reader to
 * ignore it.
 */
export const configurationInventory: readonly ConfigurationEntry[] = [
  {
    name: "NODE_ENV",
    services: [PlayableService.Backend, PlayableService.Website, PlayableService.Dashboard],
    purpose: "What libraries assume about optimization, caching and error detail.",
    secret: false,
    fallback: "development",
    example: "development",
    allowed: ["development", "test", "production"],
  },
  {
    name: "PLAYABLE_ENVIRONMENT",
    services: [PlayableService.Backend, PlayableService.Website, PlayableService.Dashboard],
    purpose: "Which deployment this is, which decides what data and credentials it may reach.",
    secret: false,
    fallback: "local",
    example: "local",
    allowed: ["local", "preview", "staging", "production"],
  },
  {
    name: "HOST",
    services: [PlayableService.Backend, PlayableService.Website, PlayableService.Dashboard],
    purpose: "The address to bind to. Deployments bind dual-stack, so the value there is a bare colon pair.",
    secret: false,
    fallback: "127.0.0.1",
    example: "127.0.0.1",
  },
  {
    name: "PORT",
    services: [PlayableService.Backend, PlayableService.Website, PlayableService.Dashboard],
    purpose: "The port to listen on.",
    secret: false,
    fallback: "4000",
    example: "4000",
  },
  {
    name: "DATABASE_URL",
    services: [PlayableService.Backend],
    purpose: "The runtime and ordinary migration connection, owned by the unprivileged application role.",
    secret: true,
    example: "postgresql://playable:password@127.0.0.1:5432/playable",
    owner: "Zerops project secrets for every deployment, and the developer's own machine locally.",
    rotation: "When the application role's password changes, and immediately on any suspected exposure.",
  },
  {
    name: "DB_MIGRATION_ROLE",
    services: [PlayableService.Backend],
    purpose: "The exact role migrations must run as. The runner aborts when the connected role differs.",
    secret: false,
    example: "playable",
  },
  {
    name: "BACKEND_URL",
    services: [PlayableService.Website, PlayableService.Dashboard],
    purpose: "Where to reach the backend. Inside a deployment this is the internal service address.",
    secret: false,
    example: "http://127.0.0.1:4000",
  },
  {
    name: "ALLOWED_ORIGINS",
    services: [PlayableService.Backend],
    purpose: "Comma-separated origins the backend accepts browser requests from.",
    secret: false,
    fallback: "http://127.0.0.1:3000",
    example: "http://127.0.0.1:3000",
  },
];

/**
 * The connection reserved for administrative database repairs.
 *
 * Named here so that the name is fixed and searchable, and kept out of
 * {@link configurationInventory} so that no loader, no `.env.example` and no
 * deployment definition can present it as ordinary configuration. Reaching it
 * is a deliberate act in a script written for one repair, per the ownership
 * rules in the private secret document.
 */
export const administrativeDatabaseUrlName = "PRODUCTION_DATABASE_ADMIN_URL";

/**
 * The administrative connection, described but never offered.
 *
 * It carries the same shape as an inventory entry so the private secret
 * document covers it, and it stays outside {@link configurationInventory} so
 * that no loader resolves it, no `.env.example` invites it and no deployment
 * definition carries it.
 */
export const administrativeDatabaseEntry: ConfigurationEntry = {
  name: administrativeDatabaseUrlName,
  services: [],
  purpose: "A privileged connection for one approved repair at a time. No service may start with it set.",
  secret: true,
  example: "postgresql://admin:password@host:5432/playable",
  owner: "Held outside the repository and outside the deployment, and pasted into a single repair session.",
  rotation: "Immediately after every repair that used it.",
};

/**
 * The entries one service reads.
 *
 * @param service - The service being configured.
 * @returns Its entries, in inventory order.
 */
export function entriesForService(service: PlayableServiceName): readonly ConfigurationEntry[] {
  return configurationInventory.filter((entry) => entry.services.includes(service));
}
