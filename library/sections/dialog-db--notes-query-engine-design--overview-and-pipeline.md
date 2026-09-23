---
title: The three-stage pipeline (descriptor → rule → conjunction)
source: notes/query-engine-design.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A query rule moves through three types, each with a stronger guarantee than the last. **`DeductiveRuleDescriptor`** is the serializable wire form — a conclusion plus `when`/`unless` propositions, just data. **`DeductiveRule`** is the *analyzed* rule: analysis verifies every invariant (type inference, required-head-not-optional, Coalesce contracts, conclusion grounding) and proves the body *plannable*, so a `DeductiveRule` is **plannable by construction**; it holds the premises (authored order), inferred types, and dependency graph (the SIPS). **`Conjunction`** is the concrete execution plan for a *specific* scope, produced on demand by `DeductiveRule::plan(scope)` and evaluated by `Conjunction::evaluate`. `InductiveRule` is the assertion-shaped sibling (same pipeline, differs only at evaluation); the `Rule` enum wraps either.

A query rule moves through three stages, each producing a type with a stronger guarantee than the last:

```
DeductiveRuleDescriptor  ──analyze──▶  DeductiveRule  ──plan(scope)──▶  Conjunction  ──evaluate──▶ rows
   (parsed data,                       (analyzed: verified,             (concrete plan
    no guarantees)                      plannable by construction)       for a scope)
```

- **`DeductiveRuleDescriptor`**: the serializable / wire form — a conclusion plus `when`/`unless` propositions. Just data.
- **`DeductiveRule`**: the *analyzed* rule. Analysis verifies every invariant (type inference, required-head-not-optional, Coalesce contracts, conclusion grounding) and proves the body is *plannable*. It holds the premises (authored order), the inferred types, and the dependency graph (the SIPS). Because analysis ran, a `DeductiveRule` is **plannable by construction**.
- **`Conjunction`**: the concrete execution plan for a *specific* scope, produced on demand by `DeductiveRule::plan(scope)`. The plan is what evaluates (`Conjunction::evaluate`). The rule analyzes and plans; the plan it returns evaluates.

`InductiveRule` is the assertion-shaped sibling (same pipeline; differs only at evaluation). The `Rule` enum wraps either.

Source: [notes/query-engine-design.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/query-engine-design.md) at commit `ebd8f739`.
