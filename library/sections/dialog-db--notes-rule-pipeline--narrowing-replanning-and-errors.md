---
title: Plan-time narrowing, evaluation, replanning, and the error table
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

> Abstract: Type narrowing happens **once at plan time**, not on every evaluation, and only on an in-flight working copy — the user's `Premise` values stay untouched. It matters because the evaluator's Absent-fallback decision keys on `is.is_optional()`: without narrowing an optional attribute always emits an Absent row on a lookup miss even when a sibling required premise guarantees the variable is Present, and the downstream join then filters the spurious rows; with narrowing, inference that stripped `Nothing` makes `is_optional()` return `false` so the fallback row is never emitted (a real saving for any rule mixing optional and required bindings on one variable). `Conjunction::evaluate(selection, env)` folds the already-narrowed steps in order with no `TypeEnv` threaded through; standalone top-level queries plan with an empty `TypeEnv` so the rewrite is a no-op. **Replanning** (`Conjunction::plan(&new_scope)`) reruns the planner for a different scope (adornment-based); inference is idempotent and stable across reorderings. A "what lives where" table and an errors table close the note.

The rewrite happens **once at plan time**, not on every evaluation. The user-supplied `Premise` values stay untouched; only the in-flight working copy in the `Plan` reflects rule-level narrowing.

## Why narrow at plan time

The evaluator's behavior depends on `is.is_optional()` for the Absent-fallback decision:

- Without narrowing, an optional attribute always emits an Absent row when its lookup misses, even when a sibling premise's required slot guarantees that variable is Present at the rule level. The downstream join then filters the spurious Absent rows.
- With narrowing, the optional attribute's `is` term reflects the rule-inferred kind. If inference stripped `Nothing` (because a sibling required premise narrowed it), `is_optional()` returns `false` and the fallback row is never emitted.

The savings are real for any rule that mixes optional and required bindings on the same variable.

## Evaluation

`Conjunction::evaluate(selection, env)` folds the steps' evaluators in order. Each step's premise is already narrowed; no `TypeEnv` is threaded through evaluation. Standalone queries (top-level `.perform()` outside any rule) plan with an empty `TypeEnv` so the rewrite is a no-op; the user's local term kinds are the sole source of optionality info.

## Replanning

`Conjunction::plan(&new_scope)` reruns the planner against a different scope (adornment-based replanning for concepts whose bindings change between callers). Type inference runs again on the fresh order; it is idempotent (re-narrowing an already-narrowed premise produces the same kinds) and stable across reorderings (inference does not depend on step order).

## What lives where

| Location | Contents |
|---|---|
| `Premise` (user-facing) | Whatever the user wrote |
| `AnalyzedRule.types` | Rule-level inferred env, shared via `Arc` |
| `AnalyzedRule.graph` | Per-premise `binds`/`needs` + `requires[]` |
| `Plan.premise` | Premise with variable terms narrowed |
| `Conjunction.steps` | Ordered `Plan`s plus cost/binds/env |

## Errors

| Source | Variant | When |
|---|---|---|
| `InferenceError::Conflict` | `TypeEnv::infer` | Slot kinds disagree for one variable |
| `AnalysisError::Inference` | `analyze` | Wraps the above |
| `AnalysisError::RequiredHeadFromOptional` | `analyze` | Inferred head admits `Nothing` |
| `AnalysisError::CoalesceTypeMismatch` | `analyze` | Coalesce contract violated |
| `TypeError::TypeInference` | `Planner::plan` | Inference error during planning |
| `TypeError::RequiredHeadFromOptional` | `DeductiveRule::new` | Wraps analysis error with rule |
| `TypeError::CoalesceTypeMismatch` | `DeductiveRule::new` | Wraps analysis error with rule |
| `TypeError::UnboundVariable` | `DeductiveRule::new` | Head var not bound by any premise (post-plan) |
| `TypeError::RequiredBindings` | `Planner::plan` | A premise's dependencies are unsatisfiable |

Source: [notes/rule-pipeline.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/rule-pipeline.md) at commit `f777fe7c`.
