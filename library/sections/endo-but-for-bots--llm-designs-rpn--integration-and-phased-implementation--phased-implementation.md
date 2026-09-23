---
title: Phased implementation
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, tooling]
status: current
notes: No reverse-lookup index added in this iteration — the existing `groupInEdges` map serves as the substrate; what was missing was an external API. Memoization layer keyed by (group, depth) is deferred behind profiling — the working set per `endo workers` call is bounded by tenant count (typically tens). The host holds the formula-graph lock for the duration of the bulk call, so memoization is correct.
parent: endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation
---

### Phase 1: Typed bulk method

- Add `host.listRetentionPaths(targetIds)` returning `Array<RetentionPath>`, with the per-segment `locator` and `mergeKind` fields surfaced from `graph.js`.
- Surface the new fields on `RetentionPathSegment` from `daemon-retention-paths.md`.
- Unit tests: best-path selection, positional preservation, missing/invalid ids, transient-only vs persistent-rooted, merged-group segments.

### Phase 2: CLI string notation and integrations

- Add `packages/cli/src/retention-path-notation.js` exporting `renderRetentionPath(path) -> string` and `parseRetentionPath(string) -> RetentionPath | undefined`. The parser is included so the CLI can validate hand-typed paths in a future search-by-path feature; the bulk method does not depend on it.
- Wire `endo workers` to `listRetentionPaths` and render with the notation.
- Add `endo paths <name-or-locator>` (defined in `daemon-retention-paths.md`) and have it print using the notation defined here.

### Phase 3: Chat tenant chip

- Tenant chip component reads the typed `RetentionPath` and renders per the styling above.
- Click on a sub-chip opens the inspector for that segment's locator.
- Copy yields the CLI notation, rendered on the client.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
