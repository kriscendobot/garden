---
title: Rule storage — `db.rule/*` facts and content-addressed rule entities
source: notes/layered-rule-resolution.md
source_repo: dialog-db/dialog-db
source_commit: 00b43561a10383175a7f794fee7cb0894b0222e7
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A deductive rule is stored as two facts (`rules.rs`): `db.rule/conclusion` `of` rule-entity `is` concept-entity (the "which rules conclude concept X" index), and `db.rule/source` `of` rule-entity `is` the rule body as canonical dag-cbor `DeductiveRuleDescriptor` (a `Value::Bytes`, hydrated with `DeductiveRule::decode`). The rule-entity is content-addressed — `rule:<base58(blake3(dag-cbor(descriptor)))>` (`DeductiveRule::this`) — and because dag-cbor canonicalizes map keys, the encoding is a pure function of the descriptor even though a premise's terms come from a `HashMap`, needing no manual key sorting. The body is stored as `Value::Bytes` rather than `Value::Record` because Record is not yet supported end-to-end through the index; the bytes are opaque to the query layer either way. These attribute names are a dialog-repository convention like `dialog.session/*` and `dialog.meta/*`.

A deductive rule is stored as two facts (see `rules.rs`):

- `db.rule/conclusion` `of` rule-entity `is` concept-entity — the index; "which rules conclude concept X".
- `db.rule/source` `of` rule-entity `is` the rule body as canonical dag-cbor `DeductiveRuleDescriptor` (a `Value::Bytes`), hydrated with `DeductiveRule::decode`.

The rule-entity is content-addressed: `rule:<base58(blake3(dag-cbor(descriptor))))>` (`DeductiveRule::this`). dag-cbor canonicalizes map keys, so the encoding is a pure function of the descriptor even though a premise's terms come from a `HashMap` — no manual key sorting. (Stored as `Value::Bytes` rather than `Value::Record`: Record isn't yet supported end-to-end through the index; the bytes are opaque to the query layer either way.)

These attribute names are a dialog-repository convention, like `dialog.session/*` and `dialog.meta/*`.

Source: [notes/layered-rule-resolution.md](https://github.com/dialog-db/dialog-db/blob/00b43561a10383175a7f794fee7cb0894b0222e7/notes/layered-rule-resolution.md) at commit `00b43561`.
