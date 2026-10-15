---
kind: result
role: typist
host: endolin-garden-ece02cb4
at: 2026-10-15T09:49:16Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/pass-style/src/types.d.ts:100-103` makes `ParcelObject` an unconditional member of `Passable`. That widens `PureData` and the declared return of `toThrowable` to admit a Parcel, although `toThrowable` rejects the `parcel` pass style at runtime (`packages/pass-style/src/passStyleOf.js:390,432-437`). It also widens the public `Key` alias (`packages/patterns/src/types.ts:74-77`) even though key validation rejects Parcels. Parameterize or exclude `ParcelObject` for these constrained aliases and add type contracts for the boundary. [rule: AGENTS.md § TypeScript usage]

Review target: PR #1392, typist dispatch; diff base `origin/build/sturdyref-ses-accommodation-282679d`.

Self-improvement: nothing this time.
