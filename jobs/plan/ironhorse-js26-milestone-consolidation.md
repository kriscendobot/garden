---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-16T06:50:55Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Consolidate the over-fragmented ironhorse js-26 causal sub-children into per-family MILESTONE jobs.

Maintainer decision 2026-08-16 (liaison session): adopt the re-scope proposal's milestone-PR direction. This job does the consolidation half. It is parked behind a go-ahead because ironhorse development is PAUSED for the week to conserve budget; promote it when the pause lifts.

Problem being fixed: roughly 37 remaining parked `ironhorse-js-26-*` sub-children were minted under the disproven "one handler closes a cluster" assumption, most carrying the 2400s default handler budget. The campaign's own full-suite report shows 23,427 actionable cases with 41% (9,510) being generic `ironhorse-aborted` — the downstream shadow of a few missing engine prerequisites, not independent small gaps. So a per-cluster handler cannot close a cluster, and these jobs will keep hitting the wall and being reaped.

Do this:
1. Read the remaining parked `ironhorse-js-26-*` jobs and the re-scope proposal's per-cluster tables (job `ironhorse-test262-residual-rescope`, in jobs/tada/).
2. Replace them with ONE milestone job per family, each with a REAL handler budget (10800-14000s, under the ~3.98h claim cap) and an explicit prerequisite-first ordering where the data shows aborts cascading off a shared missing prerequisite.
3. Each milestone job must COMMIT PARTIAL GAINS rather than requiring full closure of its family. A milestone that lands measurable progress and reports its residual is a success, not a failure. Say this in each job body.
4. Park every milestone job with gate go-ahead. Promote NOTHING.

Explicitly out of scope, by maintainer decision: the Intl/ECMA-402 formatter families are DEFERRED INDEFINITELY (the 9 `ironhorse-intl-*` plus 3 `numberformat-*` parked jobs, already annotated). Do not fold them into milestones or revive them.

Also out of scope here: the multi-day clusters that need a different vehicle than a handler — RegExp u/v/unicode (the u/v flag alone is 2,870 cases and cross-cutting, gating Temporal, String and language aborts), TypedArray/ArrayBuffer, language expr/stmt/eval, Object/Array/Reflect/Proxy MOP, eval/Function/dynamic-import. Report how you would decompose these; do not mint handler jobs for them.

Do not touch `ironhorse-branch-regression-fixer`, which runs separately and repairs the branch back to baseline.

handler-timeout: 7200
