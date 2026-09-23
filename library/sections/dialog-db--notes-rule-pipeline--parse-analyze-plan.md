---
title: The rule compilation pipeline — Parse, Analyze, Plan
source: notes/rule-pipeline.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A deductive rule moves from user-supplied premises to an executable plan in three phases, each producing a stronger artifact. **Parse:** the `DeductiveRuleDescriptor` (serialized form — a conclusion plus `when`/`unless` premise lists with user terms) yields `Vec<Premise>` plus the conclusion, carrying no type information beyond what the user wrote at the term layer. **Analyze:** `analyze(conclusion, &steps) -> Result<AnalyzedRule, AnalysisError>` runs three sub-steps — type inference (unify slot kinds for every named variable across positive premises; negation premises filter rather than contribute), a required-head check (a conclusion variable whose inferred kind admits `Nothing` raises `RequiredHeadFromOptional`), and Coalesce-contract validation. The immutable `AnalyzedRule` carries the conclusion, premises in planned order, the shared `types: TypeEnv`, and a `DependencyGraph` of per-premise `binds`/`needs` plus precomputed `requires[]` ordering edges. **Plan:** `Planner::from(premises).plan(&scope)` does greedy cost-based ordering (repeatedly pick the cheapest viable premise), re-runs inference on the ordered steps, narrows each step's premise, and stamps the results into `Plan` values assembled into a `Conjunction`.

A deductive rule moves from user-supplied premises to an executable plan in three phases:

```
   ┌──────────┐    ┌──────────┐    ┌──────────┐
   │  Parse   │ -> │ Analyze  │ -> │  Plan    │
   └──────────┘    └──────────┘    └──────────┘
        |               |               |
   Descriptor       AnalyzedRule    Conjunction
```

## Parse

`DeductiveRuleDescriptor` is the serialized form: a conclusion (`ConceptDescriptor`) plus `when`/`unless` premise lists with user-supplied terms. Parsing yields `Vec<Premise>` plus the conclusion. No type information beyond what the user wrote at the term layer (`Term<Option<String>>` carries `String | Nothing`; `Term<Any>::var("x")` carries nothing).

## Analyze

`rule::analyzer::analyze(conclusion, &steps) -> Result<AnalyzedRule, AnalysisError>`, in three sub-steps:

1. **Type inference** (`rule::types::TypeEnv::infer`). For every named variable referenced by any positive premise's slots, unify the slot kinds. Negation premises do not contribute; they filter on already-bound values rather than introducing them. Untyped slots contribute their *requirement shape*: a `Required` slot says "any present value" (`Primitive::ALL`), an `Optional` slot says "any present or absent" (`Primitive::ANY`). Output: name → inferred `Kind`. Errors: `Conflict { variable, reason }` when slots disagree on the kind for a given variable.
2. **Required-head check.** For each conclusion variable, if the inferred kind admits `Nothing`, raise `RequiredHeadFromOptional { variable }`. The rule cannot produce `Absent` in a required slot.
3. **Coalesce contract validation.** Every `Constraint::Coalesce` runs against a fresh unifier context. The contract: source is `Optional<α>`, fallback and is both unify with `α`. Errors: `CoalesceTypeMismatch { reason }`.

The output, `AnalyzedRule`, carries `conclusion: ConceptDescriptor`; `premises: Vec<Premise>` in planned order; `types: Arc<TypeEnv>`, the inferred environment, shared; and `graph: DependencyGraph`, per-premise `binds`/`needs` plus precomputed `requires[]` edges for ordering. Analysis is rule-scoped and its result immutable. Its errors are pre-rule (they do not reference a `DeductiveRule`); `DeductiveRule::new` wraps them in the corresponding `TypeError::*` variants for display.

## Plan

`Planner::from(premises).plan(&scope) -> Result<Conjunction, TypeError>`:

1. Greedy cost-based ordering: repeatedly pick the cheapest viable premise, remove it from candidates, advance the bound-vars set (the existing `Candidate`/`Schema`/`Parameters` walk).
2. Run `TypeEnv::infer` on the ordered steps. Failures surface as `TypeError::TypeInference`.
3. **Narrow each step's premise** via `apply_types(premise, &types)`. The rewrite replaces variable terms (currently only `AttributeQuery::is`) with copies carrying the inferred kind. Negated propositions are walked too; a negation over an optional attribute picks up the same narrowing.
4. Stamp the rewritten premises into `Plan` values; assemble the `Conjunction`.

Source: [notes/rule-pipeline.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/rule-pipeline.md) at commit `f777fe7c`.
