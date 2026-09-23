---
id: value-based-cas
aliases: [value-based CAS, compare-and-swap, "compare and swap", staleness detection, "Proof<T>", Proof wrapper, Provenance, "Provenance origin period moment", causal assertion, Cause, "db/cas", ":db/cas", Datomic cas, causal information, provenance-aware query, Conclusion<T>]
topics: [change-propagation, datalog-query]
---

# value-based-cas

Dialog's decision on how much of its causal/provenance model reaches the query API (`notes/causal-information-design-decision.md`). A tool reading records may want the `Cause` of what it read so its later edit can carry compare-and-swap assumptions the transactor verifies — but the clean derive-macro domain structs have nowhere to attach a `Cause`, and every claim's provenance is a `Provenance { origin, period, moment }` (an Automerge-actor-ID plus a session-aware Lamport-like counter). Three surfacing options were weighed: Cause-carrying custom primitive types (leaks infra into the domain, 32 bytes per scalar), a `Proof<T>` query wrapper (clean but taxes every author), and weakened **value-based CAS** (tell the transactor the observed *value*, not the *cause*). The decision: **causal information is a querying concern, not a modeling concern.** The default query returns plain domain types; `Proof<T>` is an opt-in for the rare provenance-needing tool; value-based CAS — following Datomic's `:db/cas` (`[:db/cas e a old new]`, abort if the current value isn't `old`) — covers the common staleness case, because "is the value still what I read?" catches the meaningful conflicts and the value-matches-but-cause-differs window is both rare (single-writer service-worker transactor) and not clearly actionable. Cardinality resolution (transactor-side, driven by the current claim set) is kept a *separate concern* from staleness detection, which a universal wrapper would wrongly conflate.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-causal-information-design-decision--problem-and-causal-model](../sections/dialog-db--notes-causal-information-design-decision--problem-and-causal-model.md) | Why capturing Cause enables CAS, and Dialog's planned Provenance {origin, period, moment} model and causal assertions. |
| [dialog-db--notes-causal-information-design-decision--options-considered](../sections/dialog-db--notes-causal-information-design-decision--options-considered.md) | Custom primitives vs Proof<T> vs value-based CAS; how Automerge (no CAS) and Datomic (value-based :db/cas) handle it. |
| [dialog-db--notes-causal-information-design-decision--decision-causal-is-querying-concern](../sections/dialog-db--notes-causal-information-design-decision--decision-causal-is-querying-concern.md) | The decision and its five rationale points; Proof<T> as an opt-in, cardinality vs staleness kept separate. |

## See also

- [[divergence-clock]] — the causal-ordering/provenance model whose surfacing this decision keeps optional.
- [[record-value]] — the value model (capturing a resolved `Claim`/artifact in a binding) this provenance decision interacts with.
- [[merkle-crdt]] — Automerge's no-CAS CRDT-merge alternative, contrasted here as prior art.
- [[schema-on-read]] — the concept/attribute query layer that returns the plain domain types this decision keeps as the default.
