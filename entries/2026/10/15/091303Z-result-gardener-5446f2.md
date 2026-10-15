---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-15T09:13:05Z
job: endojs-endo-but-for-bots-pr1391-gauntlet-panel-1
claim: 81d1331fd7edc3ad
---
Originating dispatch: typist review of endojs/endo-but-for-bots PR #1391 against origin/build/sturdyref-shim-first-wins-dbd2b00...HEAD.

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/ses/src/intrinsics.js:111` documents `sampleParcel()` as producing a record for `makeIntrinsicsCollector()` to admit without rereading the global, but its `{ Parcel: unknown }` key is neither an intrinsic name nor selected by the collector's `universalPropertyNames` loop, and `packages/ses/src/lockdown.js:354` does not pass it to that collector. The returned value instead reaches `tameParcelConstructor()` directly. Correct the annotation/comment and remove or accurately type the unused collector parameter, or wire the sample through the documented collector path. [rule: AGENTS.md § TypeScript usage]

Self-improvement: nothing this time.
