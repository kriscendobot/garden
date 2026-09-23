---
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 12
status: current
---

> Abstract: The query-notation reference for Dialog's domain models. Dialog describes attributes, concepts, and deductive rules in **two one-to-one notations**: a **formal notation** (explicit JSON or YAML, every reference structural, defined by the companion JSON schema) and an **abbreviated notation** (a YAML-only authoring shorthand with addressing, structural inference, and punning that expands into the formal form). Twelve sections cover: the two-notation overview; structural identity (`(the, type, cardinality)` for attributes, the sorted attribute set for concepts, `the` as the nominal escape hatch); selectors/domains/names (the 64-byte selector budget and the domain/name regexps); the formal **attribute** (value-type enum, cardinality-as-succession, future concept-typed/symbol-enum values); the formal **concept** (`with` required, `maybe` optional and unshipped); formal **deductive rules** (`deduce`/`when`/`unless`, variables and `this`, conjunction, disjunction as separate rules, negation as failure); **constraints and formulas** (equality `==`; the math/text/logic built-ins); **assertions and claims** (assert/retract, the `{the, of, is, cause}` claim, the `{by, period, moment}` provenance); and the four abbreviated-notation sections (addressing, attribute, concept, deductive rules). Companion schema ingested separately as [`dialog-db--notes-notation-schema`](dialog-db--notes-notation-schema.md).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--notes-notation--overview.md) | datalog-query | current |
| [structural-identity](../sections/dialog-db--notes-notation--structural-identity.md) | datalog-query | current |
| [selectors-domains-and-names](../sections/dialog-db--notes-notation--selectors-domains-and-names.md) | datalog-query | current |
| [attribute](../sections/dialog-db--notes-notation--attribute.md) | datalog-query | current |
| [concept](../sections/dialog-db--notes-notation--concept.md) | datalog-query | current |
| [deductive-rules](../sections/dialog-db--notes-notation--deductive-rules.md) | datalog-query | current |
| [constraints-and-formulas](../sections/dialog-db--notes-notation--constraints-and-formulas.md) | datalog-query | current |
| [assertions-and-claims](../sections/dialog-db--notes-notation--assertions-and-claims.md) | datalog-query | current |
| [abbreviated-addressing](../sections/dialog-db--notes-notation--abbreviated-addressing.md) | datalog-query | current |
| [abbreviated-attribute](../sections/dialog-db--notes-notation--abbreviated-attribute.md) | datalog-query | current |
| [abbreviated-concept](../sections/dialog-db--notes-notation--abbreviated-concept.md) | datalog-query | current |
| [abbreviated-deductive-rules](../sections/dialog-db--notes-notation--abbreviated-deductive-rules.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; file at its own last-touch commit `bde506d7` (2026-07-05), authored by Irakli Gozalishvili.
- The prose reference for the notation the Rust-API and architecture docs use; its authoritative machine shape is the companion [`dialog-db--notes-notation-schema`](dialog-db--notes-notation-schema.md) (`notes/notation/schema.json`).
