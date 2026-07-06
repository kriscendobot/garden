---
title: Code/paper pointers; types are checked, not advisory
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

> Abstract: The implementation map — `rule.rs` (`Compile`: analyze → verify → plannable), `rule/analyzer.rs` (`analyze`, `AnalyzedRule`, `DependencyGraph` = the SIPS `≺`), `rule/types.rs` (`TypeEnv::infer`), `planner.rs` (greedy SIPS-selection), `planner/feasibility.rs` (`feasible`/`categorize` = the binding function `f`, `Infeasible`), `planner/plan.rs` (the `Plan` IR, `apply_types`, `Conjunction` evaluation), `optional.rs` (`OptionalAttributeQuery` left-join), `schema.rs` (`Requirement`/`Group` + cost constants) — plus the paper bibliography. **Types are enforced, not advisory:** rule-level inference runs once at analysis and is checked at evaluation — typed scan slots filter facts outside the term's kind (`Type::admits`), `Match::bind` validates kinds as a last-resort check, and `Equality` propagates `Absent` only into terms admitting `Nothing`. An `Absent` binding matches nothing in any scalar slot in both polarities; narrowing is positive-polarity-only, and negated subqueries are typed in their own context.

**Pointers (code):**

- `rust/dialog-query/src/rule.rs`: the `Compile` trait (analyze → verify → plannable rule).
- `rust/dialog-query/src/rule/analyzer.rs`: `analyze`, `AnalyzedRule`, `DependencyGraph` (the SIPS `≺`).
- `rust/dialog-query/src/rule/types.rs`: `TypeEnv::infer` (inference + narrowing inputs).
- `rust/dialog-query/src/planner.rs`: the greedy SIPS-selection planner.
- `rust/dialog-query/src/planner/feasibility.rs`: `feasible` / `categorize` (the binding function `f`) and `Infeasible`.
- `rust/dialog-query/src/planner/plan.rs`: the `Plan` operator IR, type projection (`apply_types`), and `Conjunction` evaluation.
- `rust/dialog-query/src/optional.rs`: `OptionalAttributeQuery`, the optional lookup (left-join) operator.
- `rust/dialog-query/src/schema.rs`: `Requirement` / `Group` (feasibility input) and the cost constants (`Cardinality::estimate`, the SIPS-selection cost model).

**Pointers (papers):** Beeri & Ramakrishnan, *On the power of magic* (magic sets); Balbin, Port, Ramamohanarao, Meenakshi 1991, *Efficient bottom-up computation of queries on stratified databases* (SIPS, adornment, the cost-bracketing quote); Alviano, *Dynamic Magic Sets* thesis (SIPS Def. 3.1.3, demand-driven memoized adornment); Tekle & Liu, *Extended Magic for Negation* (arXiv:1909.08246; the `n.p` construction + FBF); Radul & Sussman, *The Art of the Propagator* / Radul, *Propagation Networks* (multidirectional constraints, cells, merge); Budiu et al., *DBSP: Automatic Incremental View Maintenance for Rich Query Languages* (VLDB 2023; the incremental algebra); Gupta, Mumick, Subrahmanian 1993 (DRed) and Tekle & Liu (FBF) for incremental maintenance with retraction.

**Types are checked, not advisory.** Rule-level inference (one pass, at analysis) is enforced at evaluation: typed scan slots filter facts whose value falls outside the term's kind (`Type::admits`), `Match::bind` validates kinds as a last-resort contract check, and `Equality` propagates `Absent` only into terms that explicitly admit `Nothing`. An `Absent` binding matches nothing in any scalar slot, in both polarities; under negation this makes "has no nickname" pass "unless the nickname is banned" instead of matching every banned value. Narrowing is positive-polarity-only; negated subqueries are typed in their own context (see `polarity-and-negation.md`).

Source: [notes/query-engine-design.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/query-engine-design.md) at commit `ebd8f739`.
