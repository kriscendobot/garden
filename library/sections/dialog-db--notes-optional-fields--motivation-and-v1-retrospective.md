---
title: Motivation and the v1 retrospective
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

> Abstract: Three concerns drove the v2 type-system redesign. **Set-widening optionality**: a concept field `nickname: Option<Nickname>` should realize as `Some(value)` when the fact exists and `None` when it doesn't; the storage layer never persists `None`, so `Optional<T>` is the set `T ∪ {Absent}` with the subtype rule `T ⊆ Optional<T>` and absence is realized at query time. **Generic formulas**: `math/sum`, `string/concat`, `to_string` conceptually want polymorphism (`forall T: Numeric. (T, T) → T`) but the schema language cannot express it, forcing either type-erasure (lossy) or one-variant-per-type (verbose) — `Equality` was already extracted into its own `Constraint::Equality` variant for exactly this reason. **Range predicates and inference**: future predicate constraints (`<`, `starts_with`) want to *narrow* a variable's type by which predicate uses it, needing an inference framework that propagates type information across a rule body and feeds the storage layer for index-range optimization. The shipped work addresses set-widening end-to-end and lays the unifier groundwork for inference; generic formulas are the part that didn't ship. The paired v1 retrospective diagnoses five debts — two parallel type taxonomies, a recursive `Optional` variant admitting `Option<Option<...>>`, type-erasure loss needing a parallel `optional_producers` set, a type-erased `UnwrapOr`, and marker traits used as structural fences — all symptoms of one root cause: *the descriptor cannot express optionality*.

## The three motivating concerns

1. **Set-widening optionality.** Concept fields like `nickname: Option<Nickname>` should realize as `Some(value)` when the underlying fact exists and `None` when it doesn't. The storage layer never persists `None`; absence is realized at query time. `Optional<T>` is the set `T ∪ {Absent}` with the subtype rule `T ⊆ Optional<T>`.

2. **Generic formulas.** Today's engine has formulas like `math/sum`, `string/concat`, `to_string` that conceptually want to be polymorphic (`forall T: Numeric. (T, T) → T`) but the schema language has no way to express that, so they end up either type-erased (lossy) or one variant per concrete type (verbose). `Equality` was extracted into its own `Constraint::Equality` variant precisely because it couldn't fit the formula schema's "fixed input/output types" model.

3. **Range predicates and inference.** Future predicate constraints (`<`, `<=`, `starts_with`, etc.) want to *narrow the type* of a variable based on which predicate uses it. `starts_with` implies `String | Symbol`. The planner needs an inference framework that propagates type information across a rule body and feeds back into the storage layer (e.g. for index-range optimization).

The shipped work addresses (1) end-to-end and lays the unifier groundwork for (3). Concern (2) is the part that didn't ship.

## v1 retrospective

v1 shipped working set-widening but accumulated debt:

1. Two parallel type taxonomies (schema-layer `Type` + descriptor `Option<ValueType>`).
2. Recursive `DynamicAttributeQuery::Optional` variant: `Option<Option<...>>` not prevented by the type signature.
3. Type-erasure loss in `From<Term<Option<T>>> for Term<Any>`, needing a parallel `optional_producers: HashSet<String>` to recover the lost info at planning time.
4. `UnwrapOr` builder type-erased at the boundary, accepted mismatched output types.
5. Marker traits as load-bearing structural fences rather than ergonomic bounds.

Each is a symptom of "the descriptor can't express optionality." v2 fixes this at the root: the descriptor expresses optionality, type variables, and constraint sets uniformly via the same `Type` enum.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
