---
title: The structural turn (M1, feat/operator-ir) — optionality leaves the associative layer
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

> Abstract: The note's closing addendum records that the flat, kind-driven shipped design was reworked once more on `feat/operator-ir` (M1) into a *structural* contract, and this is the version that matches the `scalar-associative-layer` cluster. Five deltas. **Optionality left the associative layer**: `Resolution` and the `is`-term-driven `Absent` fallback are gone — a raw attribute lookup is scalar (zero rows on miss) and `AttributeQueryAll::new` strips a `Nothing`-bearing kind; set-widening is now realized by the `OptionalAttributeQuery` left-join at the semantic (concept) layer. **One encoding**: the `Requirement::Optional -> Primitive::ANY` inference rule is deleted; a slot's `Requirement` speaks only of *derivability*, and absence is declared exclusively through content types (the `OptionalAttributeQuery` schema, concept optional fields), so a consuming rule's `TypeEnv` is truthful. **Filter semantics everywhere**: a scalar context (scan slot, formula input, equality against a non-widened term) matches nothing against an `Absent` binding — the row is filtered in positive and negative polarity alike — and `Coalesce` is the explicit opt-in for a default, now ordered strictly after the premise resolving its source. **Polarity discipline**: negated premises neither contribute to inference nor receive positive narrowing; `unless` over a `maybe` premise is rejected at analysis (`NegatedOptional`). **Checked, not advisory**: inference runs once per rule (`Planner::with_types`), typed scans filter values outside the term's kind (`Type::admits`), `Match::bind` validates kinds as a contract check, and `RequiredHeadFromOptional` fires across concept boundaries now that the boundary declares its widening. User-facing semantics live in `notes/guide.md`.

The flat shipped design described in the preceding sections was reworked once more; the contract is now structural rather than kind-driven. The deltas:

- **Optionality left the associative layer.** `Resolution` and the `is`-term-driven `Absent` fallback are gone; a raw attribute lookup is scalar (zero rows on miss), and `AttributeQueryAll::new` strips a `Nothing`-bearing kind. Set-widening is realized by the `OptionalAttributeQuery` left-join at the semantic layer (see `notes/scalar-associative-layer.md`).
- **One encoding.** The `Requirement::Optional -> Primitive::ANY` inference rule is deleted: a slot's `Requirement` speaks only of derivability, and absence is declared exclusively through content types (`OptionalAttributeQuery` schema, concept optional fields). The concept boundary schema now widens optional fields, so a consuming rule's `TypeEnv` is truthful.
- **Filter semantics, everywhere.** A scalar context (scan slot, formula input, equality against a non-widened term) matches nothing against an `Absent` binding: the row is filtered, in positive and negative polarity alike. `Coalesce` is the explicit opt-in for a default, and it now orders strictly after the premise resolving its source.
- **Polarity discipline.** Negated premises neither contribute to inference nor receive the positive narrowing (`notes/polarity-and-negation.md`); `unless` over a `maybe` premise is rejected at analysis (`NegatedOptional`).
- **Checked, not advisory.** Inference runs once per rule (analysis; `Planner::with_types`), typed scans filter values outside the term's kind (`Type::admits`), and `Match::bind` validates kinds as a contract check. `RequiredHeadFromOptional` also fires across concept boundaries now that the boundary declares its widening.

User-facing semantics: `notes/guide.md`.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
