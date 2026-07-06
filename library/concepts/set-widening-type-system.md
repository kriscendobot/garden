---
id: set-widening-type-system
aliases: [set-widening, "set widening", "Optional<T>", "T ∪ {Absent}", "T ⊆ Optional<T>", Nothing bit, Primitive::NOTHING, Primitive::ANY, unifier, "unifier::Context", Robinson unification, type inference, rule-level type inference, TypeScheme, SchemeBody, rank-1 polymorphism, polymorphic formulas, Coalesce, "Constraint::Coalesce", unwrap_or, Resolution policy, RequiredHeadFromOptional, AnalyzedRule, TypeEnv, "optional fields v2"]
topics: [datalog-query]
---

# set-widening-type-system

Dialog's v2 type system for optionality in the query engine, as designed in `notes/optional-fields.md` and shipped (in a flatter form) under `rust/dialog-query/`. Optionality is **set-widening**: `Optional<T>` is the set `T ∪ {Absent}` with the subtype rule `T ⊆ Optional<T>`, and absence is realized at query time — the storage layer never persists `None`. What shipped encodes optionality as a `Nothing` **bit** in a `Primitive` bitfield rather than a wrapping `Optional` constructor (a `Type` carrying `Nothing` *is* the set-widened thing; `Type::optional()` is idempotent, so nested optionality is structurally impossible), and does type inference **over a rule's variables** via a Robinson unifier (`unifier::Context`), not over a formula's. The rank-1 polymorphic-*formula* machinery the design proposed (`TypeScheme`/`SchemeBody`/`SchemeType`, `instantiate`/`generalize`) **did not ship** for want of a concrete consumer — inference over a rule's variables is enough to make optional fields work end-to-end, so `Coalesce` polymorphism is expressed ad-hoc as `Constraint::Coalesce` rather than a registered scheme. A later `feat/operator-ir` structural turn moved optionality out of the associative (raw-triple) layer entirely: a scalar attribute lookup yields zero rows on miss, and set-widening is realized by an `OptionalAttributeQuery` left-join at the semantic layer with filter-not-fabricate semantics.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-optional-fields--overview](../sections/dialog-db--notes-optional-fields--overview.md) | The design-contract-vs-shipped split and the ✅/⚠️ annotation discipline. |
| [dialog-db--notes-optional-fields--motivation-and-v1-retrospective](../sections/dialog-db--notes-optional-fields--motivation-and-v1-retrospective.md) | The three motivating concerns and the five v1 debts, all rooted in "the descriptor can't express optionality." |
| [dialog-db--notes-optional-fields--v2-type-system-and-unifier](../sections/dialog-db--notes-optional-fields--v2-type-system-and-unifier.md) | Proposed Definite/Optional vs shipped flatter Type + the Nothing-bit encoding and Robinson unifier. |
| [dialog-db--notes-optional-fields--type-schemes-the-unshipped-polymorphism](../sections/dialog-db--notes-optional-fields--type-schemes-the-unshipped-polymorphism.md) | Why the polymorphic-formula TypeScheme machinery was deferred and what it would take to ship. |
| [dialog-db--notes-optional-fields--rule-analysis-descriptor-and-resolution](../sections/dialog-db--notes-optional-fields--rule-analysis-descriptor-and-resolution.md) | AnalyzedRule/TypeEnv, TypeDescriptor::kind, and the derived Resolution policy. |
| [dialog-db--notes-optional-fields--coalesce-slice7-and-marker-traits](../sections/dialog-db--notes-optional-fields--coalesce-slice7-and-marker-traits.md) | Coalesce as a constraint not a formula, RequiredHeadFromOptional, and the double-optional-preventing marker traits. |
| [dialog-db--notes-optional-fields--deferred-followups-and-acceptance](../sections/dialog-db--notes-optional-fields--deferred-followups-and-acceptance.md) | The deferred follow-ups, the shipped acceptance subset, and the settled open questions. |
| [dialog-db--notes-optional-fields--structural-turn-operator-ir-addendum](../sections/dialog-db--notes-optional-fields--structural-turn-operator-ir-addendum.md) | The feat/operator-ir rework: optionality leaves the associative layer for a semantic-layer left-join. |
| [dialog-db--notes-guide--absent-is-a-claim](../sections/dialog-db--notes-guide--absent-is-a-claim.md) | User-facing: the three variable states (unbound/Present/Absent), set-widening as a positive claim about the store, and why a concept needs a required attribute. |
| [dialog-db--notes-guide--consuming-optional-values-filter-by-default](../sections/dialog-db--notes-guide--consuming-optional-values-filter-by-default.md) | Occurrence-typing narrowing filters Absent rows by default; Coalesce/unwrap_or is the explicit-default opt-in, ordered after its source. |
| [dialog-db--notes-guide--producing-values-heads-are-contracts](../sections/dialog-db--notes-guide--producing-values-heads-are-contracts.md) | Required head fields promise presence, so binding one from a maybe is rejected (RequiredHeadFromOptional); discharge optionality first. |
| [dialog-db--notes-guide--negation-and-absence](../sections/dialog-db--notes-guide--negation-and-absence.md) | You cannot negate an optional field (NegatedOptional), and narrowing is computed from positive premises only. |
| [dialog-db--notes-guide--where-errors-surface](../sections/dialog-db--notes-guide--where-errors-surface.md) | Compile-time type meets vs evaluation-time membership; dialog filters where PostgreSQL errors and SQLite coerces. |
| [dialog-db--notes-guide--inference-in-an-open-world](../sections/dialog-db--notes-guide--inference-in-an-open-world.md) | Open-world soundness with no required annotation; no implicit numeric promotion; inspectable via TypeEnv::explain/narrowings/dead_optionality. |

## See also

- [[optional-attribute-query]] — the semantic-layer left-join (`OptionalAttributeQuery`/`Plan::OptionalScan`) that the structural turn made the sole home of set-widening.
- [[formula-scheme]] — the value/type "filter, don't fabricate" discipline; polymorphic literals are the type-strata parallel to `Coalesce`'s opt-in for absence.
- [[schema-on-read]] — the concept/attribute semantic layer that owns optionality once the associative layer is scalar-only.
- [[record-value]] — the compound-atomic-value half of Dialog's value model, deferred alongside this type half.
