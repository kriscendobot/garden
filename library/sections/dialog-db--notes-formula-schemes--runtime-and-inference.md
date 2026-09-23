---
title: Scheme runtime dispatch and per-use inference
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

> Abstract: How a scheme-polymorphic formula runs and infers. **Runtime**: a registered formula must serve every instantiation, and Rust cannot call a generic function with a runtime-chosen type without enumerating somewhere — the enumeration lives in exactly one place. The value lattice's numeric set is *closed* (`UnsignedInt`, `SignedInt`, `Float`), so `dialog-query` provides one hand-written visitor (`with_numeric(data_type, visitor)`) routing to the matching monomorphization, and the derive emits a visitor impl per generic formula. Per row: the instantiation type is read from the bound input values, `compute::<N>` runs, and the result is a `Value` of that same type; other bounds (COMPARABLE, STRING_LIKE) get their own closed-set visitors when needed. **Inference**: when `TypeEnv::infer` walks a `Sum` premise, the scheme allocates one fresh unifier variable with the NUMERIC constraint and contributes it as the slot type of `of`, `with`, and `is` together (per-use instantiation of a rank-1 scheme); the unifier's per-variable `Primitive` constraint *is* the bounded type variable, and `unify` returning the principal meet surfaces composed results. Consequences: `sum(?age, 1, ?next)` with `?age: u64` infers `?next: u64`; a downstream `Float` demand on `?next` infers `?age: Float`; a `String` demand anywhere is an empty meet (compile error); nothing known leaves all three bounded NUMERIC, stamped onto the feeding scans to filter non-numeric facts at the data boundary. **Prerequisite**: cells graduate `content_type` from a concrete `artifact::Type` to the lattice `type_system::Type` (and the unifier-facing variable form for scheme slots) — the same change the planned range-refinement predicates need.

A registered formula must serve every instantiation at runtime, and Rust cannot call a generic function with a runtime-chosen type without enumerating somewhere. The enumeration lives in exactly one place: the value lattice's numeric set is *closed* (`UnsignedInt`, `SignedInt`, `Float`), so `dialog-query` provides one hand-written visitor (`with_numeric(data_type, visitor)`) that routes to the matching monomorphization; the derive emits a visitor impl per generic formula. Per row, the instantiation type is determined from the bound input values, the matching `compute::<N>` runs, and the result is a `Value` of that same type. Other bounds (COMPARABLE, STRING_LIKE) get their own visitors when a formula needs them; each is a closed set.

## Inference: instantiate per use

When `TypeEnv::infer` walks a `Sum` premise, the scheme allocates one fresh unifier variable with the NUMERIC constraint and contributes it as the slot type of `of`, `with`, and `is` together — the per-use instantiation of a rank-1 scheme. The unifier's per-variable `Primitive` constraint *is* the bounded type variable, and `unify` returning the principal meet (landed ahead of this work) is what lets composed unifications surface their results. Consequences:

- `sum(?age, 1, ?next)` with `?age` known `u64` infers `?next : u64`.
- `?next` demanded as `Float` downstream infers `?age : Float`.
- `?age` demanded as `String` anywhere is an empty meet: compile error.
- Nothing known: all three stay bounded NUMERIC, and the bound is stamped onto the feeding scans (filtering non-numeric facts at the data boundary, per the narrow-on-use semantics).

## Prerequisite: cells carry lattice types

`Cell::content_type` is today a single concrete `artifact::Type`; a scheme-bounded or range-refined slot cannot be expressed. Cells graduate to the lattice `type_system::Type` (and, for scheme slots, to the unifier-facing variable form). This same change is the prerequisite for the planned range-refinement predicates, where a cell's type is "String with prefix `p`".

Source: [notes/formula-schemes.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/formula-schemes.md) at commit `d8c90b90`.
