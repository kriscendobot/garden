---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-15T13:33:44Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-3
claim: b3a15fac5edf7bdc
---
Reviewed only `origin/build/sturdyref-ses-accommodation-a10a201...HEAD` in `/home/kris/garden/scratch/project-wt-endojs--3f1fd58298f5-73e3c927` for endojs/endo-but-for-bots PR #1392.

Result: request changes. The Parcel brand-check fixture tests a reentrant call, a throwing check, and a non-boolean result, but not the stateful boundary that follows an exception: a later, separate candidate that `isParcel` accepts with literal `true`. Add that scenario to prove `checking` is released in the `finally` path; without it, a regression that leaves the latch set turns every later genuine Parcel into a rejection and the present `throwing` scenario still passes because its second result is intentionally truthy rather than `true`.

Covered: real Parcel recognition and repeated identity; distinct Parcels; nesting in copy arrays, records, and tagged values; forged prototype; marker forgery; remotable precedence; no-opening; subclass rejection; absent, malformed, replacement, captured, reentrant, throwing, and unfrozen pre-shim globals; rank identity and singleton exceptions; nonidentity rank rejection; marshal and encoder rejection in both formats; pattern and key rejection; membrane rejection; type surface. Missing: exceptional brand-check followed by a genuine accepted candidate.

Rule: skills/adversarial-tests/SKILL.md section Boundary and section Timing and state.

Self-improvement: nothing this time.
