---
title: "Fast collection: indexing and cost"
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

The existing `listRetentionPaths(targetId)` in `graph.js` is a BFS upstream from the target group through `groupInEdges`; cost is linear in the number of paths times the average path length. For the bulk variant, the daemon walks each target independently; shared upstream work is not memoized in this iteration because the working set per `endo workers` call is bounded by the tenant count (typically tens, not thousands).

If profiling shows shared upstream work dominating, the followup is a memoization layer keyed by `(group, depth)` that caches partial upstream walks across targets within a single bulk call. The memoization is correct because the graph cannot mutate during the call; the host holds the formula-graph lock for the duration.

No reverse-lookup index is added in this iteration. The `groupInEdges` map already serves as the reverse-lookup substrate; the missing piece was an externally accessible API and the shape of the bulk return.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
