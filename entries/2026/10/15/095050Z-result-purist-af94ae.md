---
kind: result
role: purist
host: endolin-garden-ece02cb4
at: 2026-10-15T09:50:52Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
Originating dispatch: `endojs-endo-but-for-bots-pr1392-gauntlet-panel-2`; PR #1392; reviewed only `origin/build/sturdyref-ses-accommodation-282679d...HEAD` in the supplied worktree.

**Verdict:** request-changes

**Findings:**
- **must-fix** — `packages/pass-style/src/types.d.ts:75-103` expands `Passable` to include `ParcelObject`, and `packages/pass-style/src/passStyleOf.js:281-307` consequently makes `assertPassable`/`isPassable` accept it, although the established contract on line 76 says a Passable can be marshalled and `packages/marshal/src/encodeToCapData.js:244-246` / `encodeToSmallcaps.js:270-272` reject this exact value. This lets APIs such as `makeTagged` admit a value as a `Passable` and defer failure until a boundary serialization, so the newly introduced member does not meet the family contract. Either give parcels a stable slot representation before admitting them to `Passable`, or keep them outside `Passable`/`isPassable` until that representation exists. [rule: roles/jurors/purist/AGENT.md]

Self-improvement: nothing this time.
