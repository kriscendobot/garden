---
title: Fast collection + integrations (endo workers, chat UI) + phased implementation
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
kind: index
section_count: 4
---

> Abstract: **Fast collection**: the existing `listRetentionPaths(targetId)` in `graph.js` is BFS upstream through `groupInEdges`; cost linear in path count × average path length. Bulk variant walks each target independently; shared upstream work not memoized in this iteration (working set per `endo workers` typically tens of tenants). If profiling shows shared-upstream dominance, followup is a memoization layer keyed by `(group, depth)` — correct because the graph cannot mutate during the call (host holds the formula-graph lock). **No reverse-lookup index added** — `groupInEdges` already serves as the substrate; what was missing was the external API. **Integration with `endo workers` (PR #151)**: before — `worker-7a3f\n  shared-file (eval)\n  inbox-mailhub (mail-hub)`. After — `worker-7a3f\n  @endo/pins/shared-file#eval\n  @endo/inbox:mailHub#mail-hub`. `workers.js` calls `listRetentionPaths(tenantIds)` once per worker (or once total for all workers' tenants). Left-margin pet name dropped; rendered notation is the canonical identifier. `--json` form gains a `retentionPath` field per tenant containing the typed value. **Integration with chat UI**: tenant chip consumes typed `RetentionPath`, renders as sub-chips styled by edge kind, each bound to its segment's `locator`. Root segments bold blue; pet-name edges bold default color; field edges gray italic; retention edges gray with hover tooltip showing full peer id + pet name; type suffix small-caps muted. Each sub-chip clickable → opens inspector for the segment's locator. **Copy yields the CLI string notation** (rendered on client from typed value) so chip text round-trips through copy-paste into a CLI invocation. **Phased implementation**: (1) Typed bulk method + new fields on segment + unit tests; (2) CLI `retention-path-notation.js` with `renderRetentionPath`/`parseRetentionPath`, wire `endo workers` + `endo paths`; (3) Chat tenant chip with markup rendering + click-to-inspect + copy-to-CLI-string.

Sections:

- [Fast collection: indexing and cost](endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation--fast-collection-indexing-and-cost.md)
- [Integration with `endo workers` (PR #151)](endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation--integration-with-endo-workers-pr-151.md)
- [Integration with chat UI](endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation--integration-with-chat-ui.md)
- [Phased implementation](endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation--phased-implementation.md)

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
