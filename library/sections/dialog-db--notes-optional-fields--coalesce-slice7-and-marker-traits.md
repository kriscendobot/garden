---
title: Coalesce, Slice-7 enforcement, and the marker traits
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

> Abstract: The enforcement layer that keeps optionality honest. **Coalesce / `unwrap_or`** partially shipped, but *not as a formula*: `Coalesce` is its own `Constraint::Coalesce` variant, not a formula with a `UNWRAP_OR_SCHEME`; its type contract (`source: Optional<α>, fallback: α, is: α`) is checked at rule-compile time by `Coalesce::validate(ctx)` using the shipped `unifier::Context`, but hand-rolled inside `validate` rather than declared as a reusable scheme — consistent with the broader "no schemes" decision, so Coalesce's polymorphism is expressed ad-hoc. **Slice-7 enforcement** shipped mostly: `RequiredHeadFromOptional` ships as `AnalysisError::RequiredHeadFromOptional`, flagging any conclusion variable whose inferred kind admits `Nothing`; `NegationOnOptional` is *not* a separate check — negations don't contribute to inference (they're filters) and `apply_types` rewrites their terms with rule-level kinds, so a negation reading an optional binding sees the narrowed kind; `ConceptOnlyOptionalFields` did not ship (task #80). **Marker traits** shipped: `ScalarType`/`ProductType`/`VariantType`/`OptionalType`/`DefiniteType`-family bounds prevent `Term<Option<Option<U>>>` and `Term<Option<Any>>` at the Rust API. Together these are the "checked at compile time, not merely intended" backbone: a required head cannot be fed by an optional, and double-optionals are unrepresentable in the type signature.

## Coalesce / `unwrap_or`

⚠️ **Partially shipped, but not as a formula.** `Coalesce` ships as its own constraint variant (`Constraint::Coalesce`), not as a formula with a `UNWRAP_OR_SCHEME`. Its type contract is checked at rule-compile time via `Coalesce::validate(ctx)`, which uses the shipped `unifier::Context` to verify `source: Optional<α>, fallback: α, is: α`, but the contract is hand-rolled inside `validate`, not declared as a reusable scheme.

This is consistent with the broader "no schemes" decision: without `TypeScheme` infrastructure, Coalesce's polymorphism is expressed ad-hoc rather than via a registered scheme.

## Slice 7 enforcement

✅ **Shipped (mostly).**

- `RequiredHeadFromOptional`: shipped as `AnalysisError::RequiredHeadFromOptional`. The shipped check reads the inferred `TypeEnv` and flags any conclusion variable whose inferred kind admits `Nothing`.
- `NegationOnOptional`: not shipped as a separate check. The shipped semantics: negations don't *contribute* to inference (they're filters), and `apply_types` rewrites their terms with the rule-level kinds, so a negation reading an optional binding sees the narrowed kind, not the user's local one.
- `ConceptOnlyOptionalFields`: not shipped. Captured as task #80.

## Marker traits

✅ **Shipped.** `ScalarType`/`ProductType`/`VariantType`/`OptionalType`/`DefiniteType`-family bounds prevent `Term<Option<Option<U>>>` and `Term<Option<Any>>` at the Rust API.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
