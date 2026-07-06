---
title: Feasibility vs. cost; analysis vs. planning
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

> Abstract: The engine's key design decision is a **gate/rank split**. For each premise, planning asks two *separate* questions against the variables bound so far: **Feasibility** (the gate — "can this run? what does it bind?", via `feasibility::feasible`/`categorize`, reading the schema's `Requirement` + bound slots, returning `Ok(binds)` or `Err(Infeasible::NeedsAll{…})`) and **Cost** (the rank — "if it runs, how expensive?", via `Premise::estimate`, reading only which slots are bound, *never* `Requirement`). Feasibility decides *which orderings are valid*; cost decides *which valid ordering is cheapest*; the planner only asks `estimate` of a premise `feasible` already approved. **Analysis is cost-free** — it builds the feasibility structure and dependency graph from premises alone, infers rule-wide types once, and proves a valid total order exists (satisfiability), yielding the *space* of valid orderings. **Planning selects by cost** — `plan(scope)` greedily picks the cheapest feasible premise at each step. Because the feasible space is scope-independent, analysis runs once and planning re-runs cheaply per scope (concept adornment).

For each premise, planning asks two *separate* questions against the variables bound so far:

| | **Feasibility** (the gate) | **Cost** (the rank) |
|---|---|---|
| asks | can this run? what does it bind? | if it runs, how expensive? |
| function | `feasibility::feasible` / `categorize` | `Premise::estimate` |
| reads | the schema's `Requirement` + which slots are bound | which slots are bound (an access-path choice), *never* `Requirement` |
| result | `Ok(binds)` or `Err(Infeasible::NeedsAll{…})` | a number |

Both depend on the bound set, but for different reasons. Feasibility decides *which orderings are valid*; cost decides *which valid ordering is cheapest*. The planner only ever asks `estimate` of a premise `feasible` has already approved. This gate/rank split is the key design decision (see the papers section).

- **Analysis is cost-free.** It builds the feasibility structure (binding function + dependency graph) from the premises alone, infers the rule-wide types once, and proves a valid total order exists from the empty scope (satisfiability). It never consults sizes or costs. Its output is the *space* of valid orderings. Planning consumes the analyzed types (`Planner::with_types`) and projects them onto a working copy per `plan(scope)` call; the stored premises stay in authored, un-narrowed form so the serialized descriptor round-trips unchanged.
- **Planning selects by cost.** `plan(scope)` greedily picks, at each step, the cheapest *feasible* premise under the variables bound so far; its binds extend the bound set. The plan it emits is one chosen ordering. Cost lives only here, per scope.
- **Evaluation** runs the chosen plan, threading a binding stream through each step.

Because the feasible space is scope-independent, analysis runs once and planning re-runs per scope (e.g. concept adornment: a rule used with different bound arguments re-plans cheaply against the same analysis).

Source: [notes/query-engine-design.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/query-engine-design.md) at commit `ebd8f739`.
