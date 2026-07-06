---
title: Push-pull DBSP hybrid — hypothesis validation and revised risk
source: notes/dbsp/findings.mds
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
notes: "Source document is explicitly flagged as LLM evaluation of the DBSP hypothesis, not a maintainer conclusion; read as an argument, not settled design. Companion to the earlier notes/dbsp.md exploration."
---

> Abstract: The `notes/dbsp/findings.mds` companion to `notes/dbsp.md` is an **LLM-authored evaluation** (so flagged in its own header) of whether Dialog's existing top-down Datalog engine can gain DBSP-style incremental view maintenance without losing its selective data-loading advantage. Its verdict is "strongly positive": the hard problems DBSP integration would otherwise face are already solved by the existing system, so the concerns from the earlier exploration are largely mitigated. The existing **query planner** (conjunct reordering) eliminates the "wrong ordering destroys efficiency" and cartesian-product risks; the **cycle analyzer** prevents circular-dependency deadlocks; **selective loading** already pulls only tiny slices of huge fact graphs. DBSP then adds incremental power without disruption: its **Z-set** weight-based representation aligns with fact assertion/retraction, its operators chain to match an optimized conjunct order, and an optimized query plan can translate directly into a DBSP operator chain. The residual challenges are integration-shaped rather than fundamental: building a query-plan-to-DBSP-circuit compiler, extending query analysis to selective *differential* pulling, managing operator state, and guarding against performance regression.

## Corrected context

The evaluation re-frames the earlier exploration against the system's actual assets and goals.

**Existing system assets:** a working top-down Datalog query engine; a query planner with conjunct-reordering; a cycle analyzer that rejects non-evaluable queries; selective data loading (processing tiny slices of huge fact graphs); proven efficiency and correctness in production.

**Actual goals:** (primary) add DBSP-based incremental view maintenance *without losing selective loading benefits*; (secondary) if successful, potentially unify the evaluation strategies to simplify the architecture.

## Hypothesis validation: strongly positive

Three advantages of the hybrid approach:

1. **Existing infrastructure solves critical problems.** Conjunct reordering eliminates the wrong-ordering-destroys-efficiency problem; the cycle analyzer prevents circular-dependency deadlocks; the current system already demonstrates effective selective loading.
2. **DBSP adds incremental power without disruption.** DBSP provides differential processing for view updates; its operators can be chained to match the optimized conjunct ordering; its Z-set (weight-based) representation aligns with fact assertion/retraction patterns.
3. **Natural synergy between approaches.** An optimized conjunct order translates directly to a DBSP operator chain; selective loading can determine which fact changes to pull for incremental updates; variable bindings from top-down analysis can constrain bottom-up DBSP evaluation.

The confirmed incremental-maintenance strategy: when facts change, the existing planner identifies potentially affected views; for each, the existing analysis determines the relevant fact patterns; only those fact changes are pulled (leveraging indexes); the targeted differentials flow through DBSP operators; incremental view updates compute efficiently. The key insight is that the existing query analysis *already knows which fact patterns are relevant*, and that knowledge can drive selective differential pulling.

## Revised risk assessment

The original concerns are largely mitigated because the existing system already solves them: query planning, cycle detection, cartesian-product avoidance (via conjunct reordering), and missing optimization are all provided by the current query planner.

The remaining technical challenges are integration-shaped, each rated low-to-medium complexity:

| Challenge | Complexity | Proposed solution |
|---|---|---|
| DBSP circuit construction (translating optimized plans into efficient operator chains) | Medium | A query-plan → DBSP-circuit compiler |
| Selective differential pulling (which fact changes matter for each materialized view) | Medium | Extend existing query analysis to track fact dependencies |
| State management (operator state while keeping selective-loading benefits) | Low-Medium | A persistent state layer respecting the data-loading patterns |
| Performance-regression prevention | Medium | A/B testing framework and performance monitoring |

Source: [notes/dbsp/findings.mds](https://github.com/dialog-db/dialog-db/blob/ff9f03bf29edebb429a37de62eac9bcf99312131/notes/dbsp/findings.mds) at commit `ff9f03bf`.
