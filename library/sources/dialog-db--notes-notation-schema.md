---
source: notes/notation/schema.json
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: The companion JSON Schema (draft 2020-12) that is the normative definition of Dialog's **formal notation** — the machine-readable shape the prose reference [`dialog-db--notes-notation`](dialog-db--notes-notation.md) narrates. One section captures the full `$defs` graph: Attribute (with the 64-byte `the` pattern), Cardinality, Assert/ScalarType/ConceptRef/SymbolEnum, Concept/NamedRelations/AttributeRef, Rule/Premise/FormulaRef/ConstraintRef, MathFormula/TextFormula/LogicFormula/EqualityConstraint, Term/Variable/Constant, and Claim/Provenance. Tracked as its own source so its idempotency anchor follows `notes/notation/schema.json` independently of the prose file.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [json-schema](../sections/dialog-db--notes-notation-schema--json-schema.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; file at its own last-touch commit `bde506d7` (2026-07-05), authored by Irakli Gozalishvili.
- The authoritative machine shape for the notation prose reference [`dialog-db--notes-notation`](dialog-db--notes-notation.md).
