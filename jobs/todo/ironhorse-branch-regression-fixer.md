---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Restore the Ironhorse test262 branch to at least its baseline. This is the highest-priority ironhorse item: the accumulated branch is currently BELOW where it started.

Maintainer decision 2026-08-16 (liaison session): adopt the re-scope proposal's milestone-PR direction, and promote THIS regression fixer FIRST. All other ironhorse work is paused for the week to conserve budget; this job is the deliberate exception because it repairs a regression rather than extending scope.

Repo: endojs/endo-but-for-bots. Branch: the accumulated Ironhorse PR https://github.com/endojs/endo-but-for-bots/pull/970 (DRAFT). Pins: test262 be13516fb, XS oracle 23b4d6b0. Re-derive the current head at claim time; b3c3ae93 was the head at the 08-14 measurement and has since moved.

Two regression classes to repair, both introduced by accumulated campaign work, neither by any single child:

1. **6 baseline-covered paths regressed to `unsupported`** — Set.prototype.keys; String trimLeft/trimRight references; and 3 strict-mode `abort-value-differs` cases. These passed at the 08-08 baseline and do not now.

2. **185 RegExp negative over-acceptances** — the engine accepts regex patterns it must reject, because regex EARLY-ERROR VALIDATION is missing. These surface as new `ironhorse-failure` entries. Implement the early-error validation rather than skipping or relabelling the cases.

Scope discipline: repair only these two classes. Do NOT extend coverage into the wider residual (RegExp u/v, TypedArray, MOP, eval/Function, Intl) — those are deferred by maintainer decision and are separately scoped as milestone work. If a repair requires an engine prerequisite that pulls in one of those clusters, STOP and report rather than expanding.

Acceptance: re-run the authoritative full-suite report against the pinned corpus and show that the 6 baseline-covered paths are covered again and the 185 negative over-acceptances are rejected, with no new regressions elsewhere. Report the before/after histogram.

handler-timeout: 7200

<!-- garden-reaped: 1 -->
