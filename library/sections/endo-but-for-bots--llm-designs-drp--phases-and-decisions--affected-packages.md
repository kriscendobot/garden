---
title: Affected Packages
source: designs/daemon-retention-paths.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a0a4305b63f44e02e49a985243da67641fbc5552
source_date: 2026-05-01
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "follow-family release pattern" — subscription-release-by-dropping-far-reference, no explicit `unsubscribe` — is the canonical Endo subscription discipline. The `pet:<name>` label-prefix decision is principled (keeps `RetentionPathSegment` flat; unambiguous because pet names can't start with `:`); contrast with adding a separate field. The locator-as-API-key choice (not pet-name) is the canonical identifier-discipline pattern — pet names are ambiguous (same name in multiple stores), locators are unique.
parent: endo-but-for-bots--llm-designs-drp--phases-and-decisions
---

- `packages/daemon` — new methods on `EndoHost` / `Mail`, new topic for graph-edge events, microtask-coalesced wrapper for `listRetentionPaths`, export of `RetentionPath` types.
- `packages/cli` — new `endo paths` command.
- `packages/chat` — paths affordance + paths panel; integrates with the existing inventory-component, inbox-component, value-modal, and (eventually) the formula-inspector panel.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
