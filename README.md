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
| `apps/dashboard` | The internal operations dashboard. |
| `apps/desktop` | The Swift package shared by the macOS and Linux desktop apps. |
| `packages/contracts` | Types and values every workspace has to agree on. |
| `packages/docs` | Reads and validates the public technical guides. |
| `scripts` | Repository checks that no single workspace owns. |
| `Documentations` | Public technical guides, described in [its own README](Documentations/README.md). |

`apps/desktop` is a SwiftPM package rather than a pnpm workspace, so it is absent from `pnpm-workspace.yaml` and carries its own manifest. It holds `PlayableCore`, `PlayableAPI` and `PlayableStore`, which both desktop apps build on. None of the three may import a user interface framework, because a shared module that reaches into SwiftUI or GTK stops being shared. `pnpm check:desktop-modules` fails when one does.

## Documentation

Public technical guides live in `Documentations/` as Markdown, one file per chapter of the API reference. Each guide declares its own id, title and position in a front matter block, so the document is the single source and the documentation build only transports it. `Documentations/README.md` describes the format.

`Documentations/private/` stays local. It is ignored by Git and skipped by the build, and `pnpm check:documentation` fails when a file below it is tracked anyway.

## Working on Playable

The repository needs Node 22 and pnpm 10, both pinned in `package.json`. Building the desktop package additionally needs a Swift 6 toolchain.

```bash
pnpm install
pnpm verify          # structure checks, linter, types, build and tests
pnpm desktop:build   # the shared Swift modules
pnpm desktop:test
```

`pnpm verify` covers everything that runs without a Swift toolchain. The two desktop commands are separate because a machine without Swift can still work on the platform, so failing its checks there would report a missing toolchain as a broken repository.

## Continuous integration

Every pull request runs the checks its own changes can break, worked out from the merge base. A change confined to `apps/desktop` runs the Swift job alone, and a change everywhere else runs the workspace job alone. A push to `main` runs everything, because a merge commit combines two branches that were each green on their own and nothing has ever tested the result.

Branch protection requires one check, the `All checks` job. It waits for the filtered jobs and passes when every job that ran succeeded, treating a skipped job as a pass. Requiring the filtered jobs directly would block every pull request that skips one, since a skipped check never reports success.

Release automation, when there is something to release, consumes this result rather than repeating it. A release workflow runs what publishing itself needs, meaning version references, artefacts and their upload. It does not re-run the linter, the type check or the test suites, because the commit it releases has already passed them here.

## Project status

Playable is in active planning and development. The [Playable project board](https://github.com/users/phranck/projects/14) is the single source of truth for scope, priorities, implementation order, and current progress.

The desktop architecture, meaning the shared Swift modules and the two native user interfaces, is decided in the paper `PAP-PLY-001`.
