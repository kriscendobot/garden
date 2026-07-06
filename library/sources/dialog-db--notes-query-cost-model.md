---
source: notes/query-cost-model.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The query planner's cost model. Because premises resolve to range scans over a sparsely-replicated prolly-tree index where every node traversal can cost a network roundtrip, premise order (which variables are bound when) governs how tight each scan is. The model rests on three 162-byte key layouts (EAV / AEV / VAE), the rule that only a contiguous prefix from the key start constrains traversal, and index selection by longest contiguous prefix for the known slots. It assigns each premise a tier from a small cost ladder (`LOOKUP`/`RANGE_READ`/`RANGE_SCAN`/`INDEX_SCAN`/`VERIFY`) keyed on *which* of `{the, of, is}` are bound and the attribute cardinality, adds cardinality-one winner verification (sliding-window vs secondary-lookup), and orders premises greedily in O(N²). Closes with the Held-Karp exhaustive-search alternative (rejected as complexity for a margin gain when N<10) and a future hybrid greedy + Held-Karp tie-breaker.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [index-layout-and-prefix-selection](../sections/dialog-db--notes-query-cost-model--index-layout-and-prefix-selection.md) | datalog-query | current |
| [cost-function-and-verification](../sections/dialog-db--notes-query-cost-model--cost-function-and-verification.md) | datalog-query | current |
| [greedy-ordering-and-alternatives](../sections/dialog-db--notes-query-cost-model--greedy-ordering-and-alternatives.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `f777fe7c` (2026-07-05, repo HEAD), authored by Irakli Gozalishvili. The concrete cost side of the planner design; companion to `notes/planning-adornment-and-cost.md` (the feasibility/cost split) and `notes/query-engine-design.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-2` follow-on cycle (2026-07-06), part of the query-planner/rules cluster.
