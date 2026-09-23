---
title: Phased implementation strategy and success metrics
source: notes/dbsp/findings.mds
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
notes: "LLM-authored evaluation; the phased plan and timelines are the evaluation's recommendation, not committed roadmap. Note the later notes/incremental-subscriptions.md revises the architecture to demand-driven pull rather than the DBSP push this document assumes."
---

> Abstract: The `findings.mds` evaluation proposes a three-phase implementation that keeps the existing engine intact first and only later considers unifying evaluation. **Phase 1 (incremental view maintenance, the primary goal)** adds DBSP incremental maintenance *alongside* the unchanged query engine: fact changes flow through a selective puller into a DBSP circuit that emits view updates, so the existing query path stays untouched (low risk). **Phase 2 (unified evaluation, the secondary goal)** replaces top-down evaluation with a DBSP-based path — the query planner emits DBSP-compatible plans and a selective DBSP evaluator maintains current performance — migrated gradually behind A/B testing before the old path is deprecated (medium risk). **Phase 3 (advanced optimizations)** exploits the unified approach for cross-view sharing, richer incremental patterns, and distributed evaluation. Success criteria are concrete: Phase 1 requires incremental updates to match full re-evaluation exactly, sub-100ms typical view updates, and no regression to existing query performance; Phase 2 targets performance parity (±20%), similar memory profile, and a greater-than-10x speedup for view updates versus full re-evaluation. The overall recommendation is "proceed," because the hardest problems are already solved and the work can be validated incrementally.

## Phase 1 — incremental view maintenance (primary goal)

Add DBSP incremental maintenance without changing existing query evaluation:

```
[Existing Query Engine] → [Views]
                     ↓
[Fact Changes] → [Selective Puller] → [DBSP Circuit] → [View Updates]
```

Steps: build a view-dependency analyzer (extending existing query analysis); implement a selective differential puller using the existing indexes; build a DBSP circuit constructor from query plans; integrate with the existing view storage. Risk is low because the existing system is untouched and the new capability is added alongside.

## Phase 2 — unified evaluation (secondary goal)

Replace top-down evaluation with a DBSP-based approach:

```
[Query] → [Query Planner] → [DBSP Circuit Constructor] → [Selective DBSP Evaluation] → [Results]
```

Steps: modify the query planner to emit DBSP-compatible plans; create a selective DBSP evaluator that preserves current performance; migrate gradually with A/B testing; deprecate the old path once validated. Risk is medium (careful migration needed to avoid regression).

## Phase 3 — advanced optimizations

Exploit the unified approach for cross-view optimization and sharing, more sophisticated incremental patterns, and distributed evaluation strategies.

## Success metrics

- **Phase 1:** incremental updates match full re-evaluation (100% correctness); view updates under 100ms for typical fact changes; fact-retrieval efficiency held within the same order of magnitude; no impact on existing query performance.
- **Phase 2:** DBSP evaluation within ±20% of current top-down performance; similar memory-usage patterns; greater-than-10x speedup for view updates versus full re-evaluation; a single evaluation strategy replacing the dual approach.

## Recommendation and timeline

The evaluation recommends proceeding: the approach builds on a proven foundation, carries incremental risk, has a clear value proposition, is technically feasible (the hardest problems are solved), and preserves selective-loading performance. Suggested timeline: Phase 1 in 3-4 months (low risk, high value); Phase 2 in 6-8 months (medium risk, very high value); Phase 3 at 12+ months (research/optimization). Its key investment areas are a DBSP integration layer, a selective differential engine, performance monitoring, and a migration framework.

Source: [notes/dbsp/findings.mds](https://github.com/dialog-db/dialog-db/blob/ff9f03bf29edebb429a37de62eac9bcf99312131/notes/dbsp/findings.mds) at commit `ff9f03bf`.
