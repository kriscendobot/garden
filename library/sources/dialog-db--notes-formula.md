---
source: notes/formula.md
source_repo: dialog-db/dialog-db
source_commit: 6475b4d70c682b2db3f243366eff26a9484d0e91
source_date: 2026-03-09
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The user-facing reference for Dialog formulas — pure computations integrated into the query planner that compute output fields from bound input fields. A formula is a `#[derive(Formula)]` struct with `#[output]`-marked fields; the macro generates the query/rule boilerplate and an `Input` struct of the non-output fields, and the author writes `fn compute(input) -> Vec<Self>` (an empty vec guards/filters, one is the common case, many expands one input into several). Formulas are used in queries by binding fields to `Term::var`. Each output field may carry a `#[output(cost = N)]` the planner sums (default 1), and a formula must be registered in `define_formulas!` to be usable; the note lists the current built-in set (math, string, logic, conversion formulas with their `domain/name` identifiers).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [defining-and-using-formulas](../sections/dialog-db--notes-formula--defining-and-using-formulas.md) | datalog-query | current |
| [output-costs-and-built-ins](../sections/dialog-db--notes-formula--output-costs-and-built-ins.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `6475b4d7` (2026-03-09), authored by Irakli Gozalishvili. The concrete-typed formula surface this documents is generalized by `notes/formula-schemes.md` (polymorphic formula schemes) — read that for how `Sum { of: u32, ... }` becomes `Sum<N: Number>`.
- Ingested in the `scholar-ingest-dialog-db-remainder-4` follow-on cycle (2026-07-06).
