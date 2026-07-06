---
source: notes/optional-fields.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 8
status: current
---

> Abstract: "Optional Fields & Type System: v2" — Dialog's design contract for how optionality and types live in the query engine, written before implementation and then annotated in place with what actually shipped. The set-widening type system (`Optional<T> = T ∪ {Absent}`, subtype `T ⊆ Optional<T>`, absence realized at query time not persisted), the unifier-backed rule-level type inference, the `Resolution` policy, and the `Coalesce` constraint **shipped** (in `rust/dialog-query/`), in a flatter form than proposed — optionality is a `Nothing` bit in the `Primitive` bitfield rather than a wrapping `Optional` variant, and inference runs over a rule's variables via a Robinson unifier. The rank-1 polymorphic *formula* machinery (`TypeScheme`/`SchemeBody`/`SchemeType`, `instantiate`/`generalize`) **did not ship** — it had no concrete consumer — and the doc's ✅ "Shipped as" / ⚠️ "Not shipped" annotations map every proposed name to its real fate. A closing addendum records the M1 `feat/operator-ir` structural turn that moved optionality out of the associative (raw-triple) layer entirely into an `OptionalAttributeQuery` left-join at the semantic layer, giving filter-not-fabricate semantics — the shape the `scalar-associative-layer` cluster and the `optional-attribute-query` concept describe. This is the value-model/type half deferred from the record-value cycle, and it pairs with `notes/concept.md` (the concept/attribute model) and the shipped-pipeline note `notes/rule-pipeline.md`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--notes-optional-fields--overview.md) | datalog-query | current |
| [motivation-and-v1-retrospective](../sections/dialog-db--notes-optional-fields--motivation-and-v1-retrospective.md) | datalog-query | current |
| [v2-type-system-and-unifier](../sections/dialog-db--notes-optional-fields--v2-type-system-and-unifier.md) | datalog-query | current |
| [type-schemes-the-unshipped-polymorphism](../sections/dialog-db--notes-optional-fields--type-schemes-the-unshipped-polymorphism.md) | datalog-query | current |
| [rule-analysis-descriptor-and-resolution](../sections/dialog-db--notes-optional-fields--rule-analysis-descriptor-and-resolution.md) | datalog-query | current |
| [coalesce-slice7-and-marker-traits](../sections/dialog-db--notes-optional-fields--coalesce-slice7-and-marker-traits.md) | datalog-query | current |
| [deferred-followups-and-acceptance](../sections/dialog-db--notes-optional-fields--deferred-followups-and-acceptance.md) | datalog-query | current |
| [structural-turn-operator-ir-addendum](../sections/dialog-db--notes-optional-fields--structural-turn-operator-ir-addendum.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `ebd8f739` (2026-07-01), authored by Irakli Gozalishvili. The value-model/type half deferred from the `scholar-ingest-dialog-db-remainder-4` cycle (which took the `record-value`/`formula`/`formula-schemes`/`scalar-associative-layer` cluster) to anchor its own cycle.
- Companion to `notes/rule-pipeline.md` (the shipped pipeline), `notes/scalar-associative-layer.md` (where set-widening now lives), `notes/polarity-and-negation.md`, and `notes/guide.md` (user-facing semantics). Pairs with the `optional-attribute-query` and `formula-scheme` concept pages.
- Ingested in the `scholar-ingest-dialog-db-remainder-5` follow-on cycle (2026-07-06).
