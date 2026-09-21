# Documentations

This folder holds Playable's technical documentation. Everything in it is public except the one subfolder named below.

## What is public

Every Markdown file here, at any depth, is a public guide. It is published as a chapter of the API reference at `api.playable.at/docs`, and it is the single source for that chapter. Nothing is copied into the documentation site by hand, so a guide is edited here and nowhere else.

This file is the exception. It describes the folder rather than the product, so the build skips it.

## What stays local

`Documentations/private/` never leaves the machine it was written on. It is ignored by Git, skipped by the documentation build, and meant for credential ownership, incident details, contacts and anything naming infrastructure.

None of that belongs in a repository whatever its visibility is set to. A repository is cloned, backed up and mirrored by tooling, and it can be made public as easily as it was made private, so anything committed to it is committed to every copy of it permanently.

`pnpm check:documentation` fails when a file below it is tracked by Git. That catches the case `.gitignore` cannot, which is a file added before the rule existed or forced in with `git add -f`.

## What a guide looks like

A guide begins with a front matter block declaring three things about itself, then the body as ordinary Markdown.

```markdown
---
id: live-data
title: Live data
position: after-guide
---

Live sessions arrive over a single connection ...
```

| Key | Meaning |
|---|---|
| `id` | The chapter's anchor, so `#live-data`. Lowercase words joined by single hyphens, and unique across every guide. |
| `title` | The heading shown in the content, the sidebar and the search results. |
| `position` | Where the chapter sits: `before-guide`, `after-guide` or `after-reference`. |

The metadata lives in the document rather than in a separate list, so a guide that is renamed, moved or deleted takes its own entry with it. A separate list would be a second place to change, and the two would drift.

The format is not YAML. It is one `key: value` line per entry between two `---` fences, and anything else is rejected. A permissive parser would accept a typo as a valid value, and the first sign of that would be a chapter missing from the published site.

## Checking your work

```bash
pnpm check:documentation
```

It reports every problem in one pass: a document without front matter, an unknown or repeated key, a position the generator does not accept, an id two documents both claim, and any tracked private file.

A Markdown file without front matter is reported rather than skipped. A document that is silently left out of the published site is exactly the failure this arrangement exists to prevent.
