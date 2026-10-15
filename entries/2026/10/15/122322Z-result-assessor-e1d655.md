---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-15T12:23:24Z
job: endojs-endo-but-for-bots-pr1391-gauntlet-panel-2
claim: 591b6ff87c095be7
---
project: endo-but-for-bots
PR: #1391
Base: build/sturdyref-shim-first-wins-dbd2b00

**Verdict:** request-changes

**Findings:**
- must-fix: `packages/ses/src/intrinsics.js:98-157` accepts any locked class that happens to expose `open`, `locate`, and `isParcel`, then `packages/ses/src/tame-parcel-constructor.js:46-48` rewrites and hardens its prototype. This contradicts the new contract in `packages/ses/README.md:276-279`, which says lockdown throws unless the global is the `@endo/parcel` constructor. A fresh locked `class ForeignParcel` with those three static methods reaches `lockdown()` successfully. Either add an identity/credential that distinguishes the shim constructor, or state and intentionally support structural adoption rather than claiming unrelated globals are rejected. [rule: packages/ses/README.md § Compartments]

**Notes (out of scope but worth flagging):**
- Focused verification: `yarn --cwd packages/ses ava test/parcel-*.test.js` passed (18 tests).

Self-improvement: nothing this time.
