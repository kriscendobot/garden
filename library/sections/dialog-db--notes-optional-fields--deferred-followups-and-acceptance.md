---
title: Deferred follow-ups, acceptance criteria, and settled open questions
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

> Abstract: The design's own accounting of what was left for later, what it accepted, and which open questions it closed during implementation. **Deferred to follow-up branches**: type schemes for polymorphic formulas (the largest chunk); records/variants in *active* inference (they ship as `Composite::Product`/`Variant` placeholders the unifier doesn't recurse into); generic formulas at runtime; range predicates and their scan-refinement contributions; cross-rule type inference (within-rule ships, across-rule does not); `get-some` variant-elimination; the `ConceptOnlyOptionalFields` rejection (task #80); and consuming the built-but-unread `DependencyGraph` as planner input (the planner still uses `Candidate::update`'s schema-walking loop). **Acceptance criteria** landed as a shipped subset: unifier coverage for the shipping cases (identity, variable-variable, variable-concrete, occurs check, constraint conflict), all v1 end-to-end tests passing, new rule-level unification-corner tests, compile-fail doctests for `Term<Option<Option<U>>>`/`Term<Option<Any>>`, clippy/fmt clean, and the doc reflecting the final shape (this split) — with instantiation-independence/generalization and generic-formula declarations marked not-shipped and range-predicate narrowing marked infrastructure-ready-but-unused. **Open questions closed**: `TypeDescriptor::KIND` settled as non-const `kind() -> Option<Type>`; anonymous-variable lifetime settled as a per-rule `unifier::Context` with named variables allocated via `var_for_name` on first reference; error messages settled to include the offending variable name, wrapped by `Compile::compile` as `TypeError::TypeInference`.

## What's deferred to follow-up branches

- **Type schemes for polymorphic formulas** (`TypeScheme`, `SchemeBody`, `SchemeType`, `instantiate`). The doc's design intent. The largest deferred chunk.
- **Records and variants in active inference**: placeholders ship as `Composite::Product`/`Composite::Variant`; the unifier doesn't recurse into them yet.
- **Generic formulas at runtime**: formula impls that dispatch on the unified type (e.g. `Sum<T>` with separate addition paths for `u32`, `i64`, `f64`). Conditional on type schemes shipping.
- **Range predicates**: new constraint variants (`<`, `<=`, `starts_with`, etc.) and their contribution to scan refinements.
- **Cross-rule type inference**: propagating type variables across rule bodies that span multiple formulas. Within-rule inference ships; across-rule does not.
- **`get-some`**: variant-elimination premise. Builds on variant types.
- **`ConceptOnlyOptionalFields` rejection**: task #80.
- **Dependency graph as planner input**: the shipped `DependencyGraph` is built but unread; the planner still uses `Candidate::update`'s schema-walking loop.

## Acceptance criteria (the shipped subset)

- ✅ Unifier with full algorithm coverage for the cases that ship: identity, variable-variable, variable-concrete, occurs check, constraint conflict.
- ⚠️ "Instantiation independence, generalization": not shipped (no schemes).
- ✅ All v1 end-to-end tests pass.
- ✅ New tests cover unification corner cases at the *rule* level (not formula-scheme level).
- ⚠️ "Generic formula declarations": not shipped.
- ⚠️ "Range-predicate-style narrowing": infrastructure ready (`TypeEnv`, dependency graph) but no predicates use it yet.
- ✅ Compile-fail doctests for `Term<Option<Option<U>>>` and `Term<Option<Any>>`.
- ✅ Workspace clippy clean, fmt clean.
- ✅ Design doc reflects the final shape: *this* split.

## Open questions settled during implementation

1. **`TypeDescriptor::KIND` const evaluation.** Settled as non-const `kind()` returning `Option<Type>`.
2. **Anonymous variable lifetime.** Settled: per-rule `unifier::Context`; named variables allocated via `var_for_name(name)` on first reference.
3. **Error messages.** Settled: `InferenceError::Conflict` includes the offending variable name; the `Compile::compile` layer wraps it as `TypeError::TypeInference { reason }`.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
