---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-16T06:51:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PAUSE MARKER — Ironhorse test262 campaign development is paused for the week from 2026-08-16 to conserve budget. Promote this job only to record the pause lifting; it does no work itself.

Maintainer decision 2026-08-16 (liaison session), in full:
- Switch from the handler-per-cluster campaign to MILESTONE PRs.
- Promote the regression fixer FIRST (job `ironhorse-branch-regression-fixer`, dispatched 2026-08-16). This is the deliberate exception to the pause: the accumulated branch is currently BELOW its 08-08 baseline (6 baseline-covered paths regressed, 185 RegExp negative over-acceptances), and that repair is not deferrable.
- DEFER the Intl/ECMA-402 formatter families INDEFINITELY (9 `ironhorse-intl-*` + 3 `numberformat-*`, parked and annotated), despite the re-scope proposal recommending them as the best-scoped landable work.
- DROP the 11 doomed jobs and `ironhorse-resume-3-launch` (done 2026-08-16; recoverable from journal2 history).
- CONSOLIDATE the ~37 over-fragmented js-26 sub-children into per-family milestone jobs with real budgets that commit partial gains (parked as `ironhorse-js26-milestone-consolidation`, awaiting go-ahead).
- Then PAUSE ironhorse development for the week.

Budget context that drove the pause: honest campaign spend was 3,307,979 against 2,080,000 approved, 59% over, while the work was not landing.

State of the effort at pause: accumulated branch is https://github.com/endojs/endo-but-for-bots/pull/970 (DRAFT). Pins: test262 be13516fb, XS oracle 23b4d6b0. 23,427 actionable cases remain, 41% of them generic `ironhorse-aborted` cascading off a few missing engine prerequisites. Multi-day clusters still needing decomposition into a non-handler vehicle: RegExp u/v/unicode (u/v flag alone 2,870, cross-cutting), TypedArray/ArrayBuffer, language expr/stmt/eval, Object/Array/Reflect/Proxy MOP, eval/Function/dynamic-import.

To resume: promote `ironhorse-js26-milestone-consolidation` first, then the milestones it parks.
