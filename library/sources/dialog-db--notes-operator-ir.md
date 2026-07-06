---
source: notes/operator-ir.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The design document for the `feat/operator-ir` chapter — the goal, the architecture chosen, and the decisions made with their rejected alternatives. Three goals: execution on a compiled `Plan` IR rather than the AST; a rule that exists is valid (analysis as constructor, SIPS retained as data); and structural optionality that no plan order can break. The architecture realizes a strengthening type hierarchy (`DeductiveRuleDescriptor` → `DeductiveRule` → `Conjunction`), a closed `Plan` enum with `Header`, the SIPS split into `DependencyGraph` + `feasibility` with cost apart, inference-once-projected-per-scope, and set-widening confined to the `OptionalAttributeQuery` left-join. The decisions record why the dependency graph does not drive ordering, why narrowing is not stored on the rule (wire-form identity), why `AnalyzedRule` was composed not dissolved, why feasibility became stateless, why optionality is a structural operator, how `Absent` filters rather than aborts, why negation stays out of typing, and the filter-vs-error kind-checking boundary.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [goals-and-prior-state](../sections/dialog-db--notes-operator-ir--goals-and-prior-state.md) | datalog-query | current |
| [architecture](../sections/dialog-db--notes-operator-ir--architecture.md) | datalog-query, change-propagation | current |
| [decisions-and-alternatives](../sections/dialog-db--notes-operator-ir--decisions-and-alternatives.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `f777fe7c` (2026-07-05, repo HEAD), authored by Irakli Gozalishvili. Companion to `notes/planning-adornment-and-cost.md` (the feasibility/cost design this realizes), `notes/scalar-associative-layer.md` (the optionality restructure, deferred), `notes/polarity-and-negation.md` (negation typing, deferred), and `notes/query-engine-design.md` (the resulting engine).
- Ingested in the `scholar-ingest-dialog-db-remainder-2` follow-on cycle (2026-07-06), part of the query-planner/rules cluster. This design's as-built deltas are noted throughout `notes/planning-adornment-and-cost.md`.
