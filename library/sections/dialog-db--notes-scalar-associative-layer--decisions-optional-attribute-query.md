---
title: Decisions as built — OptionalAttributeQuery and the left-join operator
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

> Abstract: The restructure landed on `feat/operator-ir` and every open question is settled. **Option 1 taken** — the left-join is a first-class construct: `OptionalAttributeQuery` (premise level `Proposition::OptionalAttribute`, plan level `Plan::OptionalScan`) wraps a *scalar* `DynamicAttributeQuery`; its schema hard-requires the entity slot and set-widens the `is`/`cause` content types, so feasibility and inference need no special cases, and concept lowering emits a plain scan per required field and an `OptionalAttributeQuery` per optional field. **The `of`-required symptom patch was reverted** once the schema contract moved into `OptionalAttributeQuery`; attribute schemas are uniform again. **Term-level `Option` fate**: the `Nothing` bit lives in the type system and in the schemas that can deliver `Absent` (`OptionalAttributeQuery`, a concept's optional fields); attribute terms never carry it (`AttributeQueryAll::new` strips a `Nothing`-bearing kind at construction), while `Term<Option<T>>` remains the *declaration* surface (concept fields, coalesce sources). **Narrowing demotes**: when rule inference proves a sibling premise guarantees presence, `apply_types` demotes the `Maybe` to its inner scalar scan (`OptionalAttributeQuery::into_query`), preserving the fallback-suppression optimization the old `is`-term narrowing gave. **Cardinality::Many** rides the inner dispatch: every fact extends the row, a miss still yields exactly one `Absent` row (set-widening is per entity, not per fact). The remaining row-multiplicity guards (`saw_fact`, `entity_known`) were deleted with `Resolution`; their semantics live in `OptionalAttributeQuery::evaluate`'s four-case contract, and the user-facing semantics are documented in `notes/guide.md`.

The restructure landed on `feat/operator-ir`; every open question from the investigation is settled:

- **Option 1 taken.** The left-join is a first-class construct: `OptionalAttributeQuery` (premise level: `Proposition::OptionalAttribute`, plan level: `Plan::OptionalScan`) wraps a *scalar* `DynamicAttributeQuery`. Its schema hard-requires the entity slot and set-widens the `is`/`cause` content types, so feasibility and inference need no special cases. Concept lowering emits a plain scan per required field and an `OptionalAttributeQuery` per optional field.
- **The `of`-required symptom patch was reverted** once the schema contract moved into `OptionalAttributeQuery`; attribute schemas are uniform again.
- **Term-level `Option` fate.** The `Nothing` bit lives in the type system and in the schemas that can deliver `Absent` (`OptionalAttributeQuery`, a concept's optional fields). Attribute terms never carry it: `AttributeQueryAll::new` strips a `Nothing`-bearing kind at construction. `Term<Option<T>>` remains the *declaration* surface (concept fields, coalesce sources).
- **Narrowing demotes.** When rule inference proves a sibling premise guarantees presence, `apply_types` demotes the `Maybe` to its inner scalar scan (`OptionalAttributeQuery::into_query`), preserving the fallback-suppression optimization the old `is`-term narrowing provided.
- **Cardinality::Many** rides the inner dispatch: every fact extends the row; a miss still yields exactly one `Absent` row (set-widening is per entity, not per fact).
- The remaining row-multiplicity guards (`saw_fact`, `entity_known`) were deleted with `Resolution`; their semantics live in `OptionalAttributeQuery::evaluate`'s four-case contract. User-facing semantics are documented in `notes/guide.md`.

Source: [notes/scalar-associative-layer.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/scalar-associative-layer.md) at commit `ebd8f739`.
