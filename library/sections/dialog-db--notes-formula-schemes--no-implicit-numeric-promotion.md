---
title: No implicit numeric promotion — filter, don't coerce
source: notes/formula-schemes.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A row whose inputs cannot share the scheme variable — `sum(2u64, 3.5f64)` — is a **non-match**, not a promotion; it is filtered like every other type mismatch at a scalar slot. Three reasons in order of force: (1) **Promotion cannot be lossless here** — Datomic promotes safely because the JVM supplies BigInt/BigDecimal to widen into, but Dialog's lattice tops out at `u64`/`i64`/`f64`, where `u64 → f64` loses precision above 2^53 and `u64`/`i64` share no common type; promotion would relocate the surprise from "row excluded" to "row matched with a quietly wrong value", and the honest prerequisite is a wider value lattice (a deliberate storage-format decision). (2) **Data-dependent output types poison inference and joins** — under promotion the output type depends on sibling inputs per row, so analysis can only say NUMERIC (weakening the narrowing index-range pushdown wants), and `2u64`/`2.0f64` have distinct index keys so promoted outputs join inconsistently. (3) **Consistency** — typed scan slots already filter heterogeneous facts; a coercing formula slot would make two halves of one type system disagree. Calibrated against SQLite (coerces everything, `'abc' + 1 = 1`, never errors) and PostgreSQL (errors at runtime): dialog *filters*, keeping SQLite's "queries never die on data" ergonomics without fabricating values. The ergonomic release valve is **literals, not data**: numeric literals are polymorphic constants carrying the NUMERIC bound, instantiated per row to the data's type with a checked-lossless conversion (`1` fits everywhere; `1.5` only Float; `-1` only signed); data-derived values stay strict and explicit conversion formulas (`number/to-float`) are the opt-in for crossing strata — parallel to `Coalesce` being the explicit opt-in for absence. Errors surface at compile time (empty meets, a literal outside a cell's bound); evaluation has no type errors (non-instantiating rows are non-matches), and inference must be inspectable. Alternatives rejected: scheme labels as field attributes (invents an uncheckable annotation language), hand-written `Cells` for generic formulas only (gives up derive ergonomics), and implicit promotion (recorded with its wider-lattice prerequisite).

A row whose inputs cannot share the scheme variable — `sum(2u64, 3.5f64)` — is a **non-match**, not a promotion. Filtered, like every other type mismatch at a scalar slot. The reasons, in order of force:

1. **Promotion cannot be lossless here.** Datomic promotes safely because the JVM supplies BigInt/BigDecimal to widen into. Dialog's value lattice tops out at `u64`/`i64`/`f64`: `u64 → f64` silently loses precision above 2^53, and `u64`/`i64` have no common type covering both ranges. Promotion would not remove the runtime surprise, it would relocate it from "row excluded" to "row matched with a quietly wrong value". If promotion is ever genuinely wanted, the honest prerequisite is widening the value lattice (BigInt/Decimal) — a storage-format decision to take deliberately, not to back into.
2. **Data-dependent output types poison inference and joins.** Under promotion the output's type depends on sibling inputs per row, so analysis can only ever say NUMERIC — weakening exactly the narrowing that index-range pushdown wants — and `2u64`/`2.0f64` are distinct values with distinct index keys, so promoted outputs join inconsistently downstream.
3. **Consistency.** Typed scan slots filter heterogeneous facts; a formula slot that coerced instead would make two halves of one type system disagree.

The SQLite comparison that calibrated this: SQLite coerces everything (`'abc' + 1 = 1`) and never errors; PostgreSQL errors at runtime; dialog filters. Filtering keeps SQLite's "queries never die on data" ergonomics without fabricating values.

**The ergonomic release valve is literals, not data.** `sum(?age, 1, ?next)` must not die because `1` defaulted to the wrong width: numeric literals are *polymorphic constants* carrying the NUMERIC bound, instantiated per row to the data's type with a checked-lossless conversion (`1` fits everywhere; `1.5` can only instantiate to `Float`; `-1` only to signed). Data-derived values stay strict, and explicit conversion formulas (`number/to-float`, …) are the opt-in for crossing type strata — exactly parallel to `Coalesce` being the explicit opt-in for absence.

## Where errors surface

Compile time: empty meets (known types misaligned), literal outside a cell's bound. Evaluation: no type errors — rows that cannot instantiate the scheme are non-matches, and inference must be inspectable (the planned diagnostics surface reports what narrowed each variable and what was filtered where).

## Alternatives considered

- **Scheme labels as field attributes** (`#[scheme(a)] of: Number`): rejected. Invents an annotation language rustc cannot check, handles multi-parameter schemes awkwardly, and the `Number` newtype hides which cells share a variable.
- **Hand-written `Cells` for generic formulas only**: rejected; gives up the derive ergonomics that make formulas pleasant, precisely for the formulas users touch most.
- **Implicit promotion**: rejected above; recorded with its prerequisite (a wider value lattice) should it ever be revisited.

Source: [notes/formula-schemes.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/formula-schemes.md) at commit `d8c90b90`.
