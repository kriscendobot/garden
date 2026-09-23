---
source: notes/formula-schemes.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The design note for generic (polymorphic) formulas — `math/sum` as "forall `N` ⊆ NUMERIC: `(of: N, with: N) → is: N`" rather than a fixed `u32` signature — recording the declaration surface, the runtime model, the inference wiring, the numeric-promotion decision, and the alternatives considered. Schemes are expressed as Rust generics with a bounded type parameter (`Sum<N: Number>`), the parameter *being* the scheme variable so sharing, scoping, and multi-parameter schemes come free from rustc. At runtime one hand-written visitor per closed lattice set (`with_numeric`) routes to the matching monomorphization; at inference each use instantiates one fresh unifier variable with the bound, letting types flow bidirectionally. The load-bearing decision is **no implicit numeric promotion**: a row whose inputs cannot share the variable is a non-match (filtered), because Dialog's value lattice has nothing lossless to widen into and data-dependent output types poison inference and joins — the ergonomic release valve is polymorphic *literals*, not data. An addendum extends the machinery to a TEXTUAL bound (`starts-with` as one predicate whose prefix literal refines the kind) and to numeric comparison predicates (same shape, interval payload).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [polymorphic-scheme-declaration](../sections/dialog-db--notes-formula-schemes--polymorphic-scheme-declaration.md) | datalog-query | current |
| [runtime-and-inference](../sections/dialog-db--notes-formula-schemes--runtime-and-inference.md) | datalog-query | current |
| [no-implicit-numeric-promotion](../sections/dialog-db--notes-formula-schemes--no-implicit-numeric-promotion.md) | datalog-query | current |
| [textual-and-comparison-schemes](../sections/dialog-db--notes-formula-schemes--textual-and-comparison-schemes.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `d8c90b90` (2026-07-01), authored by Irakli Gozalishvili. Generalizes `notes/formula.md` (the concrete-typed formula surface). Companion to `notes/guide.md` (the "Inference in an open world" section is the user-facing account) and `notes/refinements.md` (the range-refinement predicates that share the lattice-typed cell prerequisite).
- Ingested in the `scholar-ingest-dialog-db-remainder-4` follow-on cycle (2026-07-06).
