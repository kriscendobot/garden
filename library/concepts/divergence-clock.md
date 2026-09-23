---
id: divergence-clock
aliases: [divergence clock, "{since, drift, at}", since drift at, commit history encoding, logical clock, vector clock, Merkle clock, "hybrid logical clock", HLC, Lamport timestamp, causal ordering, concurrent change detection, convergence preference, "longest chain rule", EAVT AEVT VEAT TEAV, atomic multi-fact update, causal reference, causal index]
topics: [change-propagation, local-first-sync]
---

# divergence-clock

Dialog's proposed logical clock for reconciling concurrent multi-writer commits across partial replicas (`notes/divergence-clock.md`, "Commit History Encoding"). It targets two properties at once — identify concurrent changes, and compare any two events without reading arbitrary tree branches — that the surveyed alternatives miss: vector clocks grow with the number of sites and need DAG traversal; Merkle clocks (hash references, essentially Dialog's current single-lineage design) can't tell two hash-`cause` assertions concurrent without DAG traversal; hybrid logical clocks are totally comparable but bad at spotting concurrency. The clock encodes each change as `{ since, drift, at }`: `since` is an increment of the highest `since` across commits in the *shared* tree (the convergence point), `drift` is the local commit count since last sync, `at` is the site id. Same-`since`/different-`at` ⇒ concurrent; any two events compare via a lexicographic `${since}/${at}/${drift}` path (replacing `at` with a change hash when needed). Embedding the clock into EAVT/AEVT/VEAT/TEAV index keys gives query-driven partial replication with concurrent facts co-located for local conflict resolution, plus a longest-chain-style **convergence preference** (frequent-pulling sites increment `since` sooner and supersede laggards, unless a site rebases at the cost of disputing agreed history). The clock is motivated by a limitation of the current same-`{the,of}`-lineage causal-reference constraint: it blocks *atomic multi-fact updates* (the `by`/`msg` misattribution).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-divergence-clock--atomic-multi-fact-reconciliation-problem](../sections/dialog-db--notes-divergence-clock--atomic-multi-fact-reconciliation-problem.md) | The two reconciliation requirements and why same-lineage causal references block atomic multi-fact updates. |
| [dialog-db--notes-divergence-clock--logical-clock-survey](../sections/dialog-db--notes-divergence-clock--logical-clock-survey.md) | Why namespace-extension, vector, Merkle, and hybrid logical clocks each fall short. |
| [dialog-db--notes-divergence-clock--divergence-clock-design](../sections/dialog-db--notes-divergence-clock--divergence-clock-design.md) | The {since, drift, at} tuple: shared-convergence-point since, local drift, site at; same-since/different-at = concurrent. |
| [dialog-db--notes-divergence-clock--indexing-and-convergence-preference](../sections/dialog-db--notes-divergence-clock--indexing-and-convergence-preference.md) | Clock-embedded EAVT/AEVT/VEAT/TEAV indexing, query-driven replication, and the convergence-over-divergence preference. |

## See also

- [[merkle-crdt]] — the current hash-reference causal model the divergence clock revises; the survey names Merkle clocks explicitly.
- [[prolly-tree]] — the content-addressed index trees the clock embeds into for query-driven partial replication.
- [[value-based-cas]] — decides how much of this provenance/causal ordering surfaces in the query API (kept opt-in).
- [[demand-driven-incremental-maintenance]] — the evaluation half of the incremental cluster; the divergence clock is the ordering half.
