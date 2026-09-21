# Playable

Playable brings live podcasts and published episodes together in one place. It is designed for discovering what is happening now, following favorite shows, sharing live moments, and continuing with recorded episodes whenever it suits the listener.

## Product vision

Playable connects the immediacy of live audio with the familiarity of a podcast library. A show should feel like one podcast regardless of whether it is currently live or available as an episode.

## Core experience

- Discover podcasts that are live right now.
- Listen to live streams and recorded episodes.
- Follow favorite podcasts and keep a personal library.
- Share a live stream through a stable Playable link.
- Continue listening across sessions without losing context.

## Repository layout

Playable is one repository holding several deliverables. Applications live under `apps/`, shared code lives under `packages/`, and the dependency runs one way only: an application may build on a package, and a package never builds on an application.

| Path | What it holds |
|---|---|
| `apps/backend` | The HTTP API serving the public and internal Playable endpoints. |
| `apps/website` | The public playable.at site, its live overview and the share routes. |
| `apps/dashboard` | The internal operations dashboard, shipped as static files. |
| `apps/worker` | Scheduled ingestion and reconciliation. Serves nothing. |
| `apps/desktop` | The Swift package shared by the macOS and Linux desktop apps. |
| `packages/contracts` | Types and values every workspace has to agree on. |
| `packages/docs` | Reads and validates the public technical guides. |
| `packages/config` | The configuration inventory, its loader and its generators. |
| `packages/observability` | Readiness checks, structured logging, redaction and the runbook source. |
| `scripts` | Repository checks that no single workspace owns. |
| `Documentations` | Public technical guides, described in [its own README](Documentations/README.md). |

`apps/desktop` is a SwiftPM package rather than a pnpm workspace, so it is absent from `pnpm-workspace.yaml` and carries its own manifest. It holds `PlayableCore`, `PlayableAPI` and `PlayableStore`, which both desktop apps build on. None of the three may import a user interface framework, because a shared module that reaches into SwiftUI or GTK stops being shared. `pnpm check:desktop-modules` fails when one does.

## Documentation

Public technical guides live in `Documentations/` as Markdown, one file per chapter of the API reference. Each guide declares its own id, title and position in a front matter block, so the document is the single source and the documentation build only transports it. `Documentations/README.md` describes the format.

`Documentations/private/` stays local. It is ignored by Git and skipped by the build, and `pnpm check:documentation` fails when a file below it is tracked anyway. `pnpm generate` writes the secret ownership record and the operations runbook there.

## Configuration

Every environment variable Playable reads is described once, in `packages/config/src/inventory.ts`. The loader validates against it, `.env.example` is generated from it, and the private record of who owns each secret is generated from it as well. Nothing restates it by hand, so nothing can disagree with it. `pnpm check:generated` fails when a generated file no longer matches its source, and `pnpm generate` brings them back in step.

A service refuses to start when a variable it needs is missing, and the error names all of them at once rather than the first.

Playable runs in four places, named by `PLAYABLE_ENVIRONMENT`: `local`, `preview`, `staging` and `production`. That is separate from `NODE_ENV` on purpose. `NODE_ENV` tells libraries whether to optimize and hide stack traces, whilst `PLAYABLE_ENVIRONMENT` decides what data and which credentials a deployment may reach. A preview and production are both `production` to any library and nothing alike in what they are allowed to touch.

### The database

`DATABASE_URL` is the runtime and ordinary migration connection, owned by the unprivileged application role. `DB_MIGRATION_ROLE` names the role migrations must run as, and the runner aborts when the connected role differs.

A `local` environment may only reach a database on this machine. A `DATABASE_URL` pointing anywhere else is rejected before the service starts, because a local run against a remote database answers every query and every answer is about somebody else's data.

`PRODUCTION_DATABASE_ADMIN_URL` is the privileged connection for an approved repair. It is deliberately absent from the inventory, so no loader resolves it and no deployment carries it, and any service refuses to start while it is set.

The PostgreSQL major version, the local port, the database name and the application role are pinned in `packages/config/src/database.ts`. The deployment definition and the generated `.env.example` read from that pin, and `pnpm check:deployment` fails when the definition disagrees with it. Local and production being two majors apart is not a warning at migration-generation time; it is a migration that applies here and fails, or applies differently, there.

### The local database

Playable runs its own PostgreSQL container, as every project on this machine does, on a port that clears the others.

```bash
docker run -d \
  --name playable \
  --restart unless-stopped \
  -e POSTGRES_PASSWORD=dev-password-local-only \
  -p 127.0.0.1:5435:5432 \
  -v playable-postgres-data:/var/lib/postgresql \
  postgres:18

docker exec playable psql -U postgres -c "create role playable with login password 'dev-password-local-only'"
docker exec playable psql -U postgres -c "create database playable owner playable"
```

The two roles are the point. `POSTGRES_USER` is deliberately unset, so the image's bootstrap superuser stays `postgres` and `playable` is created as an ordinary role that owns the database. Creating the container the obvious way, with `POSTGRES_USER=playable`, makes the application a superuser, and the guarded migration runner refuses to run as one. The rule would then hold only in production, which is the last place to meet it for the first time.

Check it with:

```bash
docker exec playable psql -U playable -d playable -tAc "select rolsuper from pg_roles where rolname = current_user"
```

It answers `f`.

## Working on Playable

The repository needs Node 22 and pnpm 10, both pinned in `package.json`. Building the desktop package additionally needs a Swift 6 toolchain.

```bash
pnpm install
cp .env.example .env  # then fill in what your machine needs
pnpm verify           # structure checks, linter, types, build and tests
pnpm desktop:build    # the shared Swift modules
pnpm desktop:test
```

`pnpm verify` covers everything that runs without a Swift toolchain. The two desktop commands are separate because a machine without Swift can still work on the platform, so failing its checks there would report a missing toolchain as a broken repository.

## Continuous integration

Every pull request runs the checks its own changes can break, worked out from the merge base. A change confined to `apps/desktop` runs the Swift job alone, and a change everywhere else runs the workspace job alone. A push to `main` runs everything, because a merge commit combines two branches that were each green on their own and nothing has ever tested the result.

Branch protection requires one check, the `All checks` job. It waits for the filtered jobs and passes when every job that ran succeeded, treating a skipped job as a pass. Requiring the filtered jobs directly would block every pull request that skips one, since a skipped check never reports success.

Release automation, when there is something to release, consumes this result rather than repeating it. A release workflow runs what publishing itself needs, meaning version references, artefacts and their upload. It does not re-run the linter, the type check or the test suites, because the commit it releases has already passed them here.

## Interface

Every colour, radius, spacing step, size and duration is a custom property in `apps/website/src/styles/tokens.css`. Nothing below that file states a value of its own, and what can be derived is derived: the radius of a nested surface is the card's radius less its padding rather than a number chosen to look right.

Icons come from [Phosphor](https://phosphoricons.com) and from nowhere else, at `duotone` weight unless a surface says otherwise. Brand marks are a separate question and come from a dedicated source, because no general family carries every logo.

Nothing imports Phosphor yet. The site currently needs no icon, and the family is recorded here rather than installed, because the decision is what has to survive and a dependency nothing uses is not the way to record one.

## Share links

A podcast has two addresses, and both open an installed app: the readable `playable.at/mein-podcast-name` and the identifier-based `playable.at/live/<id>`. The rules live in `packages/contracts` so the site, the API and the apps read one scheme, and `Documentations/share-urls.md` describes them.

The website serves `/.well-known/apple-app-site-association`, which is the half of the Universal Link claim that belongs to the site. Without it macOS concludes no app may open these links, and every shared link opens a browser however correct the app is. Its contents are generated from the reserved path list, so a page added to the site cannot be forgotten in the claim.

Until Playable's own API exists, the site reads channels from the legacy Parse backend behind `ChannelSource`. A machine without those credentials gets fixtures and says so; a deployment without them refuses to start, because a site quietly serving fixtures looks entirely healthy whilst showing nobody who is really on air.

## Operations

### Readiness

A service proves its dependencies before it accepts traffic. A check that only establishes that the process is listening proves what the network already established, so `runHealthChecks` refuses a check set with nothing in it.

Three states rather than two. A service whose cache is unreachable keeps serving and says it is degraded; a service whose schema is half-applied answers 503 and leaves rotation. Collapsing them means either removing a working service or keeping a broken one.

A check that throws reports a fixed safe sentence, never what it threw, because a database driver puts its connection string into that message. The real cause goes to the log, where it is redacted first.

### Logs

One JSON line per record. A failure carries a stable code, a unique error ID and which kind of failure it is, so the error ID a person quotes leads to the one line that explains it.

A rejected request body is logged as a warning and an unreachable dependency as an error, because the first arrives constantly and would otherwise bury the second.

A deviation that a fallback absorbed is logged as a deviation, with what the service did instead. Handling something successfully and logging nothing is how a fallback that fires on every request comes to look exactly like a system that never fails.

Redaction happens in the logger rather than at the call sites. The secret names come from the configuration inventory, so a variable marked secret there is redacted without a second edit, and credentials are matched by value as well, since a driver's error message carries a connection string under no telling field name at all.

### Backups and recovery

Zerops backs the database up nightly and keeps at least seven daily, four weekly and three monthly copies. There is no key for this in the import definition, so the intended settings live in `packages/observability/src/operations.ts` and are applied in the Zerops interface at provisioning.

The incident, rollback, manual backup and restore drill procedures are rendered by `pnpm generate` into `Documentations/private/operations-runbook.md`. The procedures are versioned; the identifiers they need are not. A repository is cloned, backed up and can change visibility, so anything committed to it is committed to every copy of it permanently, and a runbook naming real infrastructure does not belong in one.

The restore drill has never been run. It needs a provisioned database and the readiness verification from #20, and a backup nobody has restored is a hope rather than a recovery plan.

## Deployment

Playable runs on Zerops as five services. `zerops-project-import.yml` says what exists and `zerops.yml` says how each one is built and started.

| Service | What it is |
|---|---|
| `database` | PostgreSQL, provisioned by Zerops |
| `backend` | The HTTP API, publicly reachable |
| `worker` | Scheduled ingestion and reconciliation, with no port and no public access |
| `website` | The public site, publicly reachable |
| `dashboard` | Static files behind nginx, publicly reachable |

Nothing is provisioned yet. The definition exists so that creating the project is a review of something written down rather than a series of decisions made at a console, and the entry points it names are created by the issues that build each service.

`pnpm check:deployment` validates `zerops.yml` against Zerops' own schema and holds the three descriptions of the topology together: the service names in `packages/contracts`, the hostnames in the import file, and the pipelines in `zerops.yml`. A hostname is an address inside the project, so a service named in one place and not another is not a typo, it is a service nothing can reach. The check also fails when a required variable is provided by neither the pipeline nor the secrets, and when any file mentions the administrative database connection.

The schema is vendored under `scripts/schemas/`, refreshed with `pnpm schema:refresh`. Fetching it during the check would make CI depend on the network and let a change upstream turn the repository red without anything here having changed.

## Project status

Playable is in active planning and development. The [Playable project board](https://github.com/users/phranck/projects/14) is the single source of truth for scope, priorities, implementation order, and current progress.

The desktop architecture, meaning the shared Swift modules and the two native user interfaces, is decided in the paper `PAP-PLY-001`.
