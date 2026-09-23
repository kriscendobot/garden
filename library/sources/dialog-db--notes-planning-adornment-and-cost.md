---
source: notes/planning-adornment-and-cost.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The design note grounding the planner redesign in the magic-sets literature: separate feasibility (the SIPS adornment function) from cost (ranking among feasible orders), make both declarable so a rule loaded from a peer carries its binding requirements as data, and fix the cases the per-slot `Requirement` schema cannot express. It reads the papers (Balbin et al.; Alviano) to justify a per-predicate demand-driven memoized adornment with no global table; diagnoses two gaps in the current `estimate`/`Requirement` encoding (feasibility entangled-with-and-silent-about cost; no k-of-n); proposes a per-premise `adorn(bound) -> Result<Binds, Infeasible>` with a serializable `Feasibility` descriptor; adopts Radul and Sussman's propagator model (decompose multidirectional constraints into directional sub-premises rather than enrich feasibility with k-of-n, and recognize dialog-db's `Match` binding environment as an existing propagator cell-merge over a three-state `{unbound, Present, Absent}` lattice); redesigns cost as a work-class ladder sensitive to which bound variable; and specifies how analysis retains the SIPS and planning consumes it. The status header records what landed (`feasibility::feasible`/`categorize`, `Infeasible::NeedsAll`, structural `OptionalAttributeQuery`) and what stays open.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [feasibility-cost-split](../sections/dialog-db--notes-planning-adornment-and-cost--feasibility-cost-split.md) | datalog-query | current |
| [gaps-and-declarable-feasibility](../sections/dialog-db--notes-planning-adornment-and-cost--gaps-and-declarable-feasibility.md) | datalog-query | current |
| [propagator-model](../sections/dialog-db--notes-planning-adornment-and-cost--propagator-model.md) | datalog-query, change-propagation | current |
| [cost-and-consumption](../sections/dialog-db--notes-planning-adornment-and-cost--cost-and-consumption.md) | datalog-query, change-propagation | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `f777fe7c` (2026-07-05, repo HEAD), authored by Irakli Gozalishvili. Companion to `notes/incremental-subscriptions.md` (deferred); its as-built deltas are recorded in `notes/operator-ir.md` (the realized feasibility/cost split, ingested this cycle).
- Ingested in the `scholar-ingest-dialog-db-remainder-2` follow-on cycle (2026-07-06), part of the query-planner/rules cluster. The primary bridge from this cycle's material to the endo/agoric change-propagation corpus (magic-sets demand reification, propagator cells, incremental maintenance).
