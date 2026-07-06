---
title: The operator-IR architecture — type hierarchy, SIPS split, structural optionality
source: notes/operator-ir.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, change-propagation]
status: current
---

> Abstract: The type hierarchy carries the guarantees: `DeductiveRuleDescriptor` (wire data) → `DeductiveRule` (verified, plannable by construction) → `Conjunction` (a concrete plan for one scope) → rows. Analysis runs type inference, the safety checks, and builds the `DependencyGraph` from the premises before any execution order exists; the rule holds `{premises, types, graph}` and a concrete plan is produced per scope cheaply because the scope-independent work is never repeated (`InductiveRule` is the assertion-shaped sibling). **The operator IR:** `Plan` is a closed enum (`Scan`, `Maybe`, `Formula`, `Constraint`, `Concept`, `Negate`), each variant carrying its lowered payload plus a `Header { cost, binds, env }`; the syntactic premise is not stored but is reconstructable via `as_premise`. **One SIPS, two halves, cost apart:** the magic-sets SIPS `(≺, f)` is two retained artifacts — the `DependencyGraph` (the dependency index) and `feasibility::categorize`/`feasible` (the binding function) — with cost deliberately in neither, so the planner asks `estimate` only of premises feasibility approved (the Balbin separation). Inference runs once and is projected per scope. **Structural optionality:** set-widening lives in exactly one construct, the `OptionalAttributeQuery` left-join whose schema hard-requires its entity slot, so the planner cannot produce an order that changes meaning.

### The type hierarchy carries the guarantees

```
DeductiveRuleDescriptor ──analyze──▶ DeductiveRule ──plan(scope)──▶ Conjunction ──evaluate──▶ rows
   (wire data,                       (verified, plannable           (concrete plan
    no guarantees)                    by construction)               for one scope)
```

Analysis runs type inference, the safety checks (required-head, Coalesce contract, negated-optional), and builds the `DependencyGraph`, all from the premises, before any execution order exists. The rule holds the analysis (`{premises, types, graph}`); a concrete plan is produced per scope, cheaply, because the expensive scope-independent work is never repeated. `InductiveRule` is the assertion-shaped sibling on the same pipeline.

### The operator IR

`Plan` is a closed enum (`Scan`, `Maybe`, `Formula`, `Constraint`, `Concept`, `Negate`), each variant carrying its lowered payload plus a `Header { cost, binds, env }`. The syntactic premise is *not* stored; it is reconstructable from the payload (`as_premise`) for the consumers that analyze a step. Evaluation dispatches on the variant.

### One SIPS, two halves, cost apart

The magic-sets SIPS `(≺, f)` is realized as two retained artifacts: the `DependencyGraph` (`≺`, the dependency index — which premise binds what each premise needs) and `feasibility::categorize`/`feasible` (`f`, the binding function — given the bound set, what a premise binds, or which variables it still needs, named in `Infeasible::NeedsAll`). Cost is deliberately *not* part of either: the planner asks `estimate` only of premises feasibility has approved, per the Balbin separation.

### Inference once, projected everywhere

Analysis infers the rule-wide `TypeEnv` once. Planning (`Planner::with_types`) projects it onto a working copy of the premises per `plan(scope)` call: attribute value kinds are stamped, a `Maybe` whose variable is proven present demotes to a plain scan, and concept parameter terms record what the rule proved at the boundary. Projection is positive-polarity only.

### Structural optionality

Set-widening lives in exactly one construct, the `OptionalAttributeQuery` left-join, whose schema hard-requires its entity slot and declares the widened content types. The associative layer below it is scalar. Every ordering-sensitive correctness condition is schema-borne (the entity requirement, Coalesce's hard-required source), so the planner cannot produce an order that changes meaning.

Source: [notes/operator-ir.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/operator-ir.md) at commit `f777fe7c`.
