---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-18T11:55:09Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-1
claim: d9caf019107acf0a
---
refs: user dispatch for endojs/endo-but-for-bots PR #764
project: endo-but-for-bots
pr: 764

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/compartment-mapper/src/node-powers.js:42,48,59` — The patch claims to cache `URL` at module initialization, but this module caches only `Function` and `Promise`; both fallback conversion functions still look up the ambient `URL` at call time. Replacing `globalThis.URL` after module evaluation can therefore alter `fakeFileURLToPath` and `fakePathToFileURL`, defeating the stated hardening. Include `URL` in the destructuring and exercise that mutation boundary. [proposed-rule: A global-intrinsic caching change must bind every intrinsic used by the touched module and test that a later global replacement cannot affect its behavior.]

Self-improvement: nothing this time.
