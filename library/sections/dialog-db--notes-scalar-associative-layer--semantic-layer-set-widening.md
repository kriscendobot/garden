---
title: The semantic layer takes over set-widening — left-join at the concept
source: notes/scalar-associative-layer.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The set-widening currently emitted in `From<&ConceptDescriptor> for DeductiveRule` (deductive.rs L141-167) moves up. Today an optional field emits one `AttributeQuery` with an `Option`-kinded `is` (→ `Resolution::Optional`); the target has an optional field emit a **scalar** `AttributeQuery` (required, like every field) plus a *left-join / coalesce* at the projection — for the bound entity `this`, run the scalar scan; if it yields no row, supply `Absent`. This is sound precisely because the concept *always has a `this`*: required fields bind it before optional ones run, so "absent for whom?" is always answerable. Two mechanism options: (1) a **projection operator** that wraps the scalar scan (run it per input row's `this`, emit Present rows or one `Absent` row if none — the current `all.rs` fallback lifted into the concept projection where `this` is guaranteed bound); (2) **Coalesce composition** (scalar scan into a fresh var, then the existing `Coalesce` to set-widen with an `Absent` fallback — but this still needs a left-join underneath to emit-nothing-vs-emit-absent). Option 1 is the clean target: the associative scan stays pure-scalar, the concept layer owns "optional field = left-join + Absent." Blast radius: `src/attribute/query/{all,only,dynamic,mod}.rs` (~58 refs) removes `Resolution`, the Absent fallback, and the optional schema widening; `src/rule/deductive.rs` emits scalar scans + a left-join wrapper; the optional-field concept tests still pass (same observable), the standalone-optional planner tests become *invalid* and are rewritten (optionality is exercised only through concepts now), and the `is_optional()`-based type-narrowing is re-homed or removed. This is **orthogonal** to the analyze→plan / feasibility-cost / SIPS planner restructure — a layering fix that makes the planner *simpler* (no optional-scan feasibility special case), sequenced after it with the #348 `of`-required patch reverted.

The set-widening currently emitted in `From<&ConceptDescriptor> for DeductiveRule` (deductive.rs L141-167):

- **Today:** an optional field emits one `AttributeQuery` with an `Option`-kinded `is` (→ `Resolution::Optional`).
- **Target:** an optional field emits a **scalar** `AttributeQuery` (required, like every field) plus a *left-join / coalesce* at the projection: for the bound entity `this`, run the scalar scan; if it yields no row, supply `Absent` for that field. The entity is always known here (the concept binds `this` before, or the required fields do), so "absent for whom?" is always answerable.

This is sound precisely because the concept *always has a `this`*: required fields bind it; an optional field's left-join is evaluated per known entity. The associative layer never has to guess.

Mechanism options for the concept-layer set-widening (to decide when implementing):

1. **A projection operator** that wraps the scalar scan: run it for each input row's `this`; emit the Present row(s), or one `Absent` row if none. Essentially the current `all.rs` fallback logic, lifted out of `AttributeQuery` and into the concept projection where `this` is guaranteed bound.
2. **Coalesce composition:** scalar scan into a fresh var, then a `Coalesce` (which already exists) to set-widen into the field var with an `Absent` fallback. Reuses existing machinery; the projection emits `scan(this, ?tmp_present)` + `coalesce(?tmp_present → ?field, else Absent)`. Needs the scan to be a left-join (emit nothing vs. emit absent), so option 1's left-join is still needed underneath.

Option 1 (a per-entity left-join projection operator in the concept layer) is the clean target: the associative scan stays pure-scalar, the concept layer owns "optional field = left-join + Absent."

## Blast radius

- `src/attribute/query/{all,only,dynamic,mod}.rs`: remove `Resolution`, the Absent fallback, the optional schema widening. ~58 refs.
- `src/rule/deductive.rs` `From<&ConceptDescriptor>`: emit scalar scans + a left-join wrapper for optional fields instead of optional `is` terms.
- The optional-field concept tests (`it_executes_concept_with_optional_field`, `it_set_widens_optional_field_sorted_before_required`): should still pass (same observable: optional field → Absent when missing), now via the concept-layer left-join.
- The standalone-optional planner tests (`it_preserves_local_optionality…`, the optional `nickname` in `it_plans_coalesce_constraint`): these become *invalid* (a scalar layer has no optional scan). Rewrite them: optionality is exercised only through concepts now, not raw attribute queries.
- Type-narrowing / inference: `is_optional()` on the attribute `is` term goes away; the narrowing logic (`apply_types`, the `String | Nothing` widening) was *about* the optional attribute term; re-home or remove.

## Relationship to the operator-IR / analyze→plan work

This is **orthogonal** to the planner restructure (analyze→plan, feasibility/cost, SIPS). It is a layering fix in the *attribute* and *concept* layers, not the planner. The planner gets *simpler* afterward (no optional-scan feasibility special case). It should be its own chapter, sequenced after, and the #348 `of`-required patch reverted, since it is a symptom treatment this restructure removes.

Source: [notes/scalar-associative-layer.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/scalar-associative-layer.md) at commit `ebd8f739`.
