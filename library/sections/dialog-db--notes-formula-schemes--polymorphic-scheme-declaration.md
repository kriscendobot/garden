---
title: Polymorphic formula schemes — the goal and the declaration surface
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

> Abstract: Formulas should be polymorphic where their semantics are — addition on any numeric type, comparison on any comparable one, concatenation on string-likes — but today every formula fixes concrete Rust types (`Sum { of: u32, with: u32, is: u32 }`), so `math/sum` over `i64` facts matches nothing. The design carries the polymorphism in the type system: a **scheme** with a *bounded type variable*, instantiated fresh at each use site, so inference flows bidirectionally (a `u64` input narrows the output to `u64`, a `Float` output requirement narrows the inputs, a `String` anywhere is a compile-time conflict). `math/sum` becomes "forall `N` ⊆ NUMERIC: `(of: N, with: N) → is: N`" rather than a fixed `u32` signature. The declaration surface reuses Rust generics: `Sum<N: Number>` with `N` in several fields — the type parameter *is* the scheme variable, so sharing is expressed by field reuse, scoping/checking come from rustc, and multi-parameter schemes (`Convert<A: Number, B: Number>`) need no extra machinery. The bound trait carries the lattice bound as an associated constant (`<N as SchemeBound>::BOUND = Primitive::NUMERIC`), so the derive emits trait-qualified code and never matches type names syntactically — a bound without a scheme fails to compile rather than silently degrading.

Built-in and user-defined formulas should be polymorphic where their semantics are: addition works on any numeric type, comparison on any comparable one, concatenation on string-likes. Today every formula fixes concrete Rust types (`Sum { of: u32, with: u32, is: u32 }`), so `math/sum` over `i64` facts matches nothing. The type system should carry the polymorphism: a scheme with a *bounded type variable*, instantiated fresh at every use site, so that inference flows bidirectionally — a `u64` input narrows the output to `u64`, a `Float` output requirement narrows the inputs, and a `String` anywhere is a compile-time conflict.

The mental model: `math/sum` as "forall `N` ⊆ NUMERIC: `(of: N, with: N) → is: N`" rather than a fixed `u32` signature.

## Declaration: Rust generics

```rust
#[derive(Formula)]
pub struct Sum<N: Number> {
    of: N,
    with: N,
    #[output(cost = 5)]
    is: N,
}

impl<N: Number> Sum<N> {
    fn compute(input: Input<Self>) -> Vec<Self> { ... }
}
```

The type parameter *is* the scheme variable: sharing is expressed by using `N` in several fields, scoping and checking come from rustc, and multi-parameter schemes (`Convert<A: Number, B: Number>`) need no extra machinery. The bound trait carries the lattice bound as an associated constant (`<N as SchemeBound>::BOUND = Primitive::NUMERIC`), so the derive emits trait-qualified code and never matches type names syntactically — a bound without a scheme fails to compile rather than silently degrading.

Source: [notes/formula-schemes.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/formula-schemes.md) at commit `d8c90b90`.
