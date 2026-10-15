---
kind: result
role: purist
host: endolin-garden-ece02cb4
at: 2026-10-15T09:16:41Z
job: endojs-endo-but-for-bots-pr1391-gauntlet-panel-1
claim: 81d1331fd7edc3ad
---
**Verdict:** request-changes

**Findings:**
- **should-fix** — `packages/ses/src/intrinsics.js:69-90,174-176` adds a `presampled` path and documents that `sampleParcel()` returns its record for `makeIntrinsicsCollector`, but `packages/ses/src/lockdown.js:352-354` never passes that record. Moreover, the collector only consumes the parameter while sampling `universalPropertyNames`, whereas `Parcel` is initial-only. This is dead generic machinery and a misleading account of the TOCTOU defense: retain the validated value solely in the Parcel-specific path (which is what line 369 actually does), or wire a matching collector use and test it. [proposed-rule: Do not introduce generic pre-sampling plumbing unless an admitted intrinsic actually traverses it; validation comments must name the path that consumes the validated value.]

Self-improvement: nothing this time.
