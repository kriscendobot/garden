---
source: notes/refinements.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The refinement layer (dialog-db-51): how a value-level constraint a rule proves about a variable (e.g. `?a.starts_with("person/")`) travels from the predicate that proved it, through inference, to the storage boundary, where it becomes index key-range bounds (`starts-with schema → inference (meet) → planner stamp → selector → key range`). It adds a `Refined(Primitive, Refinement)` shape to `type_system::Type` (a struct-not-enum prefix so numeric intervals and Entity concept-membership extend it with fields), stamps kinds onto attribute and entity scan terms as well as the value term (`with_subject_kinds`), and gives `ArtifactSelector` prefix bounds that the scan turns into `(start, end)` key tightening. Per-segment encoding sets the ceiling: Attribute prefix ranges are exact, Entity tight to 32 bytes, Value has no pushdown (hash destroys order) until dialog-db-57's order-preserving re-encoding. Deliberate non-goals: no cost-model change, no numeric intervals yet, no new scan syntax. The same narrowed kinds feed demand covers, so subscriptions watch less and partial replication pulls less (M5).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [goal-value-constraints-to-key-ranges](../sections/dialog-db--notes-refinements--goal-value-constraints-to-key-ranges.md) | datalog-query, change-propagation | current |
| [lattice-refined-type](../sections/dialog-db--notes-refinements--lattice-refined-type.md) | datalog-query | current |
| [kinds-stamped-on-scan-terms](../sections/dialog-db--notes-refinements--kinds-stamped-on-scan-terms.md) | datalog-query | current |
| [storage-boundary-and-limits](../sections/dialog-db--notes-refinements--storage-boundary-and-limits.md) | datalog-query, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `d8c90b90` (2026-07-01), authored by Irakli Gozalishvili. Companion to `notes/formula-schemes.md` (the predicates that produce refinements) and the planned order-preserving value encoding (dialog-db-57).
- Ingested in the `scholar-ingest-dialog-db-remainder-3` follow-on cycle (2026-07-06), part of the rules/scope cluster.
