/**
 * Everything about the database that has to be the same in three places.
 *
 * The version a developer runs, the version the deployment definition asks
 * Zerops for, and the version the migrations are generated against must agree.
 * Two majors apart is not a warning at generation time: it is a migration that
 * applies locally and fails, or worse applies differently, where it matters.
 *
 * The port matters for a different reason. Every project on this machine runs
 * its own PostgreSQL container, so the wrong port reaches somebody else's
 * database. That connection succeeds, answers every query, and is wrong about
 * all of them, which is harder to notice than no database at all.
 */

/** The PostgreSQL major version Playable is developed and deployed against. */
export const postgresMajorVersion = "18";

/** The port the local container publishes, chosen to clear the other projects on this machine. */
export const localDatabasePort = 5435;

/** The database Playable owns, in every environment. */
export const databaseName = "playable";

/**
 * The role the application and its migrations connect as.
 *
 * It is not a superuser anywhere, including locally. The guarded migration
 * runner refuses to run as one, so a local role with superuser rights would
 * mean the rule is only ever exercised in production, which is the one place
 * nobody wants to discover it for the first time.
 */
export const databaseRole = "playable";

/** The password the local container is created with. It protects nothing and says so. */
export const localDatabasePassword = "dev-password-local-only";

/**
 * The Zerops service type for the pinned version.
 *
 * Single container rather than a cluster: Playable has one production
 * deployment and no availability requirement that three nodes would meet and a
 * restore would not.
 */
export const zeropsDatabaseServiceType = `postgresql:single@${postgresMajorVersion}`;

/** The image the local container runs. */
export const localDatabaseImage = `postgres:${postgresMajorVersion}`;

/**
 * The connection string for the local container.
 *
 * Generated into `.env.example` so a fresh checkout starts against Playable's
 * own database. It addresses this machine, which is the only database a local
 * environment is allowed to reach anyway.
 */
export const localDatabaseUrl = `postgresql://${databaseRole}:${localDatabasePassword}@127.0.0.1:${localDatabasePort}/${databaseName}`;
