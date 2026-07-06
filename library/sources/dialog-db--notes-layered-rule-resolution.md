---
source: notes/layered-rule-resolution.md
source_repo: dialog-db/dialog-db
source_commit: 00b43561a10383175a7f794fee7cb0894b0222e7
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: How a concept query reads deductive rules from the same layer stack it reads facts from, and why. A concept query composes a stack of layers — one **durable** layer per branch (facts from the committed tree, rules from `db.rule/*` facts on it) and a **transient** overlay layer (facts and rules from the in-memory `Changes` batch) — all unioned through one `QueryEnv` that implements both `Provider<Select>` and `Provider<SelectRules>`. A rule is stored as two `db.rule/*` facts (a conclusion index and a content-addressed dag-cbor body), resolved into a `ConceptRules` by installing durable + transient rules onto an implicit per-descriptor rule. Two caches carry different soundness disciplines: a head-tagged discovery cache plus a content-addressed hydration cache (the overlay deliberately never head-cached), and a content-addressed `PlanCache` keyed by `(rule, adornment)` owned by the branch. Writes reuse the existing `Statement` path; the cache invariants are test-covered.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [layer-stack](../sections/dialog-db--notes-layered-rule-resolution--layer-stack.md) | datalog-query | current |
| [rule-storage](../sections/dialog-db--notes-layered-rule-resolution--rule-storage.md) | datalog-query | current |
| [resolution](../sections/dialog-db--notes-layered-rule-resolution--resolution.md) | datalog-query | current |
| [caches](../sections/dialog-db--notes-layered-rule-resolution--caches.md) | datalog-query | current |
| [writes-and-tests](../sections/dialog-db--notes-layered-rule-resolution--writes-and-tests.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `00b43561` (2026-07-01), authored by Irakli Gozalishvili. The rules-in-the-layer-stack companion to `notes/rules.md` and `notes/rule-pipeline.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-3` follow-on cycle (2026-07-06), part of the rules/scope cluster.
