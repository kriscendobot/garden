---
title: Rule resolution — assembling `ConceptRules` from the layers
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

> Abstract: `QueryEnv`'s `Provider<SelectRules>::execute(concept_descriptor)` assembles rules in four steps: (1) build the **implicit** per-descriptor rule once (`ConceptRules::new`), which reads the concept's attributes directly and has no content identity (not stored); (2) for each branch gather its **durable** rules by looking up `db.rule/conclusion = concept` against the tree and hydrating each body; (3) gather **transient** rules from the overlay `Changes`; (4) install the durable + transient rules onto the implicit one and return the `ConceptRules`. The single consumer is `ConceptQuery::evaluate` (`dialog-query/.../concept/query.rs`), which calls `SelectRules`, then `ConceptRules::plan(terms, match)` to get a `Disjunction` — everything (composition, caches) sits behind that one call.

`QueryEnv`'s `Provider<SelectRules>::execute(concept_descriptor)`:

1. Build the **implicit** per-descriptor rule once (`ConceptRules::new`). It reads the concept's attributes directly; it is not stored and has no content identity.
2. For each branch, gather its **durable** rules: look up `db.rule/conclusion = concept` against the tree, hydrate each body.
3. Gather **transient** rules from the overlay `Changes`.
4. Install the durable + transient rules onto the implicit one and return the `ConceptRules`.

The single consumer is `ConceptQuery::evaluate` (`dialog-query/.../concept/query.rs`): it calls `SelectRules`, then `ConceptRules::plan(terms, match)` to get a `Disjunction`. Everything — composition, caches — sits behind that one call.

Source: [notes/layered-rule-resolution.md](https://github.com/dialog-db/dialog-db/blob/00b43561a10383175a7f794fee7cb0894b0222e7/notes/layered-rule-resolution.md) at commit `00b43561`.
