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
| `apps/website` | The public playable.at site, including the live share routes. |
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

The incident, rollback, manual backup and restore drill procedures are rendered by `pnpm generate` into `Documentations/private/operations-runbook.md`. They are rendered rather than committed because this repository is public and a runbook naming real infrastructure is a map of where to push. The procedures are versioned; the identifiers they need are not.

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
