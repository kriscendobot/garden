---
title: Phased Implementation
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

**Phase 1 — Daemon snapshot API**: export RetentionPath types; add `EndoHost.listRetentionPaths(locator)` plumbing through `graph.js`; normalize labels (pet-store emits `pet:<name>`); unit + two-daemon integration test.

**Phase 2 — Subscription API**: add `formulaGraphChangeTopic` (or extend `formulaChangeTopic`); implement `followRetentionPaths` with microtask coalescing; subscription-release test.

**Phase 3 — CLI**: `endo paths <name-or-locator>` with default + `--json` rendering.

**Phase 4 — Chat panel read-only**: paths affordance on values; panel subscribes and renders paths reactively.

**Phase 5 — Chat panel write affordances**: "Delete pet name on this path" with confirmation; "Disincarnate" / "Reincarnate" toggle on the target.

**Phase 6 — Inspector + workers-panel integration**: formula-inspector panel embeds the paths viewer; workers-panel "Pet Name Retention Paths" subsection imports the same component.

Source: [designs/daemon-retention-paths.md](https://github.com/endojs/endo-but-for-bots/blob/a0a4305b63f44e02e49a985243da67641fbc5552/designs/daemon-retention-paths.md) at commit `a0a4305b` on branch `llm`.
