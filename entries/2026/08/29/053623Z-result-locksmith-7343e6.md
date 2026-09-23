---
kind: result
role: locksmith
host: endolin-garden-ece02cb4
at: 2026-08-29T05:36:23Z
---
# locksmith review — endojs/endo-but-for-bots PR #1061 (panel seat)

Dispatch: jury seat `locksmith`, `journal/jobs/doin/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-4.md`
(gauntlet `endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet`, panel round 4).
Worktree reviewed: `scratch/project-wt-endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-panel-4-1ffe76ba`,
diff base `8c402ee89` → HEAD.

### locksmith

**Verdict:** approve

**Findings:**

None. This PR converts `packages/marshal/src/types.js`'s JSDoc `@typedef`/`@callback`
declarations into a new `packages/marshal/src/types.d.ts`, leaving `types.js` an
empty runtime twin (`export {}`), plus hardens `types.test-d.ts` with bidirectional
(`Equal<A, B>`) type pins and updates `tsconfig.json`/`.gitignore` to include the
new `.d.ts`. It is a pure type-surface refactor with no runtime behavior change:

- **No capability flow change.** Every exported name in the new `.d.ts`
  (`ConvertValToSlot`, `ConvertSlotToVal`, `Marshal`, `ToCapData`, `FromCapData`,
  `CapData`, etc., `packages/marshal/src/types.d.ts:1-185`) is a type-only
  re-expression of the identically-named JSDoc `@callback`/`@typedef` it replaces;
  none carries runtime code, so no export grants a caller a capability it did not
  already have via the prior JSDoc surface. [rule: roles/jurors/locksmith/AGENT.md]
- **No new attenuator, no boundary crossing.** `packages/marshal/index.js`'s
  `export * from './src/types.js'` re-export was already there pre-diff (only its
  eslint-disable comment gained an explanation); `rankOrder.js`'s changes
  (`packages/marshal/src/rankOrder.js:12-14,329-334`) narrow an `@import` type list
  and swap one type-assertion cast (`Exclude<PartialComparison, NaN>` →
  `RankComparison`) — no runtime cast, no capability touched. [rule: roles/jurors/locksmith/AGENT.md]
- **`types.test-d.ts` additions are compile-time-only assertions** (`expectType`/
  `expectAssignable` from `tsd`) with no capability surface of their own.
  [rule: roles/jurors/locksmith/AGENT.md]

**Notes (out of scope but worth flagging):**

None.

Self-improvement: another zero-surface round for this seat — a types-only refactor
with an empty `export {}` runtime twin has no capability edges to review by
construction. No brief change proposed.
