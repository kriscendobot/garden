---
title: Decisions
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "render on the daemon" alternative would have forced chat UI to re-parse CLI strings to discover segment boundaries — a wrong abstraction. The decision to render on the consumer (CLI string vs chat markup) means the typed `RetentionPath` is the canonical backbone. Snapshot semantics: pet names move, so a tenant's best path may change between two `endo workers` invocations; `--json` includes both locator and typed path, so scripts that want stability match on locator.
parent: endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions
---

- **Path stability across formulations.** Snapshot semantics are accepted for this iteration. Pet names move; a tenant's best path may change between two `endo workers` invocations. The `--json` payload includes both the locator and the typed `RetentionPath`, so a script that wants stability across snapshots matches on the locator. Followers and subscribers (a `followRetentionPaths`-style subscription for the bulk return) are deferred to a later design.
- **Bulk return shape.** The host returns typed `RetentionPath`, not rendered strings. Consumer flexibility wins over shared canonicality at the daemon boundary. The CLI owns its string notation; the chat UI owns its markup rendering; the typed shape is the contract that keeps them consistent.
- **Group rendering.** Merged groups render with the merge kind (`+resolver`, `+handle`) rather than just a count. The `mergeKind` field on `RetentionPathSegment` carries this information from `graph.js`'s union-find.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
