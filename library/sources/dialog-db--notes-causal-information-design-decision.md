---
source: notes/causal-information-design-decision.md
source_repo: dialog-db/dialog-db
source_commit: 6cc234ab767985e44b68090143ac33027fafb158
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: "Surfacing Causal Information in Dialog's Query API" — the design decision on how much of Dialog's provenance model reaches the query surface. A tool reading records may want the `Cause` of what it read so its edits can carry compare-and-swap assumptions the transactor verifies, but the clean derive-macro domain structs (`Employee { name, role }`) have nowhere to attach a `Cause`. The note sketches the (planned) causal model — every claim carries `Provenance { origin, period, moment }`, an Automerge-actor-ID-plus-session-aware-Lamport-counter — and weighs three surfacing options: custom Cause-carrying primitive types (leaks infra into the domain, 32 bytes per scalar), a `Proof<T>` query wrapper (clean but taxes every author), and weakened *value-based* CAS (tell the transactor the observed value, not the cause). It decides **causal information is a querying concern, not a modeling concern**: the default query returns plain domain types, `Proof<T>` is an opt-in for the rare provenance-needing tool, value-based CAS (following Datomic's `:db/cas`) covers common staleness, and cardinality resolution (transactor-side, claim-set-driven) is kept separate from staleness detection. It pairs with `notes/divergence-clock.md` (the provenance/ordering it keeps optional) and the `notes/concept.md`/`notes/record-value.md` value model, and cites Automerge and Datomic as the CAS prior art.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-causal-model](../sections/dialog-db--notes-causal-information-design-decision--problem-and-causal-model.md) | change-propagation, datalog-query | current |
| [options-considered](../sections/dialog-db--notes-causal-information-design-decision--options-considered.md) | change-propagation, datalog-query | current |
| [decision-causal-is-querying-concern](../sections/dialog-db--notes-causal-information-design-decision--decision-causal-is-querying-concern.md) | change-propagation, datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `6cc234ab` (2026-07-05), authored by Irakli Gozalishvili — the newest note in the incremental/causal cluster.
- Companion to `notes/divergence-clock.md` (the causal-ordering model whose provenance this decision keeps opt-in) and the `notes/concept.md`/`notes/record-value.md` value model. Cites Automerge and Datomic (`:db/cas`) as prior art.
- Ingested in the `scholar-ingest-dialog-db-remainder-5` follow-on cycle (2026-07-06).
