---
title: Type schemes — the unshipped polymorphic-formula machinery
source: notes/optional-fields.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The design's answer to generic formulas (`math/sum`, `to_string`) was rank-1 polymorphism via a `TypeScheme`/`SchemeBody`/`SchemeType`/`SchemeDefinite` cluster plus `Context::instantiate` to allocate fresh `VarId`s from a scheme's quantified variables. **None of it shipped** — no type with those names exists in code, and this is the design's biggest deviation. Formulas keep their existing `Schema` (no quantified variables); inference happens *over a rule's variables*, not over a formula's. It didn't ship because the PR's actual mission was narrower: make the optional-fields case work end-to-end (stop emitting spurious `Absent` rows when sibling premises narrow a variable), which needs inference over a rule's variables but not polymorphic formulas. Adding `TypeScheme` machinery would have meant building infrastructure with no current consumer, since no shipped formula is declared polymorphic. What it would take to ship: introduce a `TypeScheme` type, attach one to each formula registration, add `Context::instantiate` to allocate fresh variables from a scheme's quantified set, and have the planner invoke instantiation when it picks up a formula premise — the unifier already handles everything downstream. This is the "build the polymorphism only when a consumer needs it" discipline stated as a deliberate deferral rather than an omission.

## The proposed types

```rust
pub struct TypeScheme { ... }
pub enum SchemeBody { ... }
pub enum SchemeType { ... }
pub enum SchemeDefinite { ... }
```

⚠️ **Not shipped.** No type with any of these names exists in code. Formulas keep their existing `Schema` (no quantified variables); inference happens *over a rule's variables*, not over a formula's. This is the biggest deviation from the design.

## Why it didn't ship

The PR's actual mission was to make the optional-fields case work end-to-end (stop emitting spurious `Absent` rows when sibling premises narrow the variable). That requires inference over a rule's variables. It does not require polymorphic formulas. Adding the `TypeScheme` machinery would have meant building infrastructure with no current consumer: no shipped formula is yet declared polymorphic.

## What would need to change to ship them

Introduce a `TypeScheme` type, attach one to each formula registration in the formula registry, add `Context::instantiate` to allocate fresh `VarId`s from a scheme's quantified variables, and have the planner invoke instantiation when it picks up a formula premise. The unifier already handles everything downstream.

The largest deferred chunk of the whole design is exactly this: type schemes for polymorphic formulas (`TypeScheme`, `SchemeBody`, `SchemeType`, `instantiate`) — the doc's original design intent. The generic-formula runtime (formula impls that dispatch on the unified type, such as `Sum<T>` with separate addition paths for `u32`/`i64`/`f64`) is conditional on type schemes shipping.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
