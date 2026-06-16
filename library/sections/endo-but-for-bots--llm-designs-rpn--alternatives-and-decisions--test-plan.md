---
title: Test plan
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

- Unit (daemon): bulk method positional preservation; transient-only and unreachable cases; merged-group segments expose `mergeKind`; per-segment `locator` matches the group representative.
- Unit (CLI): notation render + parse round-trip on representative paths (single-pet-name, multi-segment with field edges, with retention edge, with merged group, transient-rooted, root-only, pet name with `:` and spaces requiring quoting).
- Integration: two-daemon test asserting `listRetentionPaths` for a peer-shared target picks the local persistent-rooted path over the cross-peer retention path per the best-path rule.
- CLI: smoke test `endo workers` renders notation strings; `--json` payload includes typed `retentionPath`.
- Chat: tenant chip renders all four segment kinds from the typed shape; copy yields the CLI notation string verbatim.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
