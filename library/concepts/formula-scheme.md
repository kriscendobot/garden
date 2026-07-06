---
id: formula-scheme
aliases: [formula scheme, polymorphic formula, bounded type variable, Sum<N: Number>, NUMERIC bound, TEXTUAL bound, no implicit numeric promotion, polymorphic literal, SchemeBound, with_numeric]
topics: [datalog-query]
---

# formula-scheme

Dialog's mechanism for making a formula polymorphic where its semantics are — `math/sum` as "forall `N` ⊆ NUMERIC: `(of: N, with: N) → is: N`" rather than a fixed `u32` signature. A scheme is a *bounded type variable* declared as a Rust generic (`Sum<N: Number>`), the type parameter being the scheme variable so field-sharing, scoping, and multi-parameter schemes come free from rustc; the bound is carried as an associated constant (`SchemeBound::BOUND = Primitive::NUMERIC`). At runtime one hand-written visitor per closed lattice set (`with_numeric`) routes to the matching monomorphization; at inference each use instantiates one fresh unifier variable with the bound, so types flow bidirectionally. The load-bearing decision is **no implicit numeric promotion**: a row whose inputs cannot share the variable is a non-match (filtered), not a coercion — Dialog's value lattice (`u64`/`i64`/`f64`) has nothing lossless to widen into, and data-dependent output types would poison inference and joins. The ergonomic release valve is *polymorphic literals* (a constant adapts losslessly to the data's type per row; data never adapts) — parallel to `Coalesce` being the explicit opt-in for absence. The same machinery extends to a TEXTUAL bound (`starts-with`, whose prefix literal refines the inferred kind and is index-pushdown-ready) and to numeric comparison predicates.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-formula-schemes--polymorphic-scheme-declaration](../sections/dialog-db--notes-formula-schemes--polymorphic-scheme-declaration.md) | The goal and the Rust-generics declaration surface; the type parameter is the scheme variable. |
| [dialog-db--notes-formula-schemes--runtime-and-inference](../sections/dialog-db--notes-formula-schemes--runtime-and-inference.md) | Closed-set runtime visitors and per-use unifier-variable inference; the lattice-typed-cells prerequisite. |
| [dialog-db--notes-formula-schemes--no-implicit-numeric-promotion](../sections/dialog-db--notes-formula-schemes--no-implicit-numeric-promotion.md) | Why a type-mismatched row is filtered rather than promoted; the SQLite/PostgreSQL calibration; literals as the release valve. |
| [dialog-db--notes-formula-schemes--textual-and-comparison-schemes](../sections/dialog-db--notes-formula-schemes--textual-and-comparison-schemes.md) | The TEXTUAL prefix predicate and numeric comparisons as schemes; prefix refinement and index pushdown. |

## See also

- [[schema-on-read]] — the schema-on-query model whose typed scan slots filter heterogeneous facts, the consistency argument scheme filtering extends.
- [[record-value]] — a sibling piece of Dialog's value/type model (compound atomic values) from the same data-model cluster.
