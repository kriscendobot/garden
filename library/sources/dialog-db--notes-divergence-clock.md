---
source: notes/divergence-clock.md
source_repo: dialog-db/dialog-db
source_commit: abb5ca3f7c1b7bde278034eed41b66207a2b1d4e
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: "Commit History Encoding" — Dialog's design for a logical clock that reconciles concurrent multi-writer commits across partial replicas. It states the two reconciliation requirements (identify concurrent changes; totally order all changes cheaply, without replicating full history), diagnoses why the current same-`{the,of}`-lineage causal-reference constraint blocks *atomic multi-fact updates* (the `by`/`msg` misattribution), and surveys the alternatives — extending causal references to schema-namespace granularity, and the vector / Merkle / hybrid-logical-clock families — showing each either grows with sites, needs DAG traversal, or can't spot concurrency. Its proposal, the **divergence clock**, encodes each change as `{ since, drift, at }`: `since` an increment of the highest `since` in the *shared* tree (the convergence point), `drift` the local commit count since last sync, `at` the site id — so same-`since`/different-`at` means concurrent, any two events compare via a `${since}/${at}/${drift}` lexicographic path, and the clock embeds into EAVT/AEVT/VEAT/TEAV index keys to give query-driven partial replication with local conflict resolution and a longest-chain-style convergence preference. This is the causal-ordering half of the incremental cluster; it complements `notes/dbsp.md`/`notes/incremental-subscriptions.md` (which own selective-pull evaluation) and `notes/causal-information-design-decision.md` (which decides how much of this provenance surfaces in the query API).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [atomic-multi-fact-reconciliation-problem](../sections/dialog-db--notes-divergence-clock--atomic-multi-fact-reconciliation-problem.md) | change-propagation, local-first-sync | current |
| [logical-clock-survey](../sections/dialog-db--notes-divergence-clock--logical-clock-survey.md) | change-propagation, local-first-sync | current |
| [divergence-clock-design](../sections/dialog-db--notes-divergence-clock--divergence-clock-design.md) | change-propagation, local-first-sync | current |
| [indexing-and-convergence-preference](../sections/dialog-db--notes-divergence-clock--indexing-and-convergence-preference.md) | change-propagation, local-first-sync | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `abb5ca3f` (2026-07-01), authored by Irakli Gozalishvili.
- Companion to `notes/dbsp.md`, `notes/incremental-subscriptions.md`, and `notes/causal-information-design-decision.md`. Draws on external logical-clock literature (vector clocks, the Merkle-CRDT paper, HLC).
- Ingested in the `scholar-ingest-dialog-db-remainder-5` follow-on cycle (2026-07-06).
