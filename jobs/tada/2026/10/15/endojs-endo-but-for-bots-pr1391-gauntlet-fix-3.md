# Fix round 3 for endojs/endo-but-for-bots PR #1391: fixes pushed, CI green

I applied the panel-3 must-fix items (review posted 2026-10-15T18:16Z) to `build/sturdyref-ses-accommodation` as four follow-up commits. The head moved from `17390624a` to `3c39e7d2e`, pushed with `safe-push-pr-head.sh` in advance mode. `ci-wait-merge.sh --no-merge` returned rc 0: 35 checks, 0 failed.

**What changed, by reviewer:**
- **decomplector (must-fix 2):** `b88f46a38 refactor(ses): define first-wins globals in a separate pre-step`.
  - The first-wins `Parcel` handling in `global-object.js` moved out of the shared install loops into its own function, `defineFirstWinsGlobals`. The loops now just skip those names.
  - I removed the first-wins branch from the universal-globals loop. It could never run, because `Parcel` is not a universal global.
  - The hard-to-read `locked` expression is now a simple two-way choice. Behavior is unchanged.
- **archivist:**
  - The `firstWinsPropertyNames` comment now says lockdown throws only for names it defines.
  - The unsupported "documented exception to the function-keyword rule" comment is replaced with the real reason: only a `function` can be called with `new`, the same pattern `%SharedURL%` uses.
  - The README now says the constructor must be constructible.
  - `tameParcelConstructor` now documents its return value.
- **typist:**
  - `ParcelSample` has narrower types: a constructor type for `Parcel`, `open` returns `Promise<unknown>`, `isParcel` returns `boolean`.
  - `SharedParcel` and `tameParcelConstructor` now have parameter and return types, and `isFirstWinsDescriptor` returns `boolean`.
  - I left the local `snapshot` typed as `Record<string, any>`. Narrowing it fails `tsc` on the `__proto__: null` initializer, and the reviewer marked it comment-only.
- **pruner:**
  - The trust model is now stated once, in the `sampleParcel` JSDoc. I removed it from the `tame-parcel-constructor.js` header and the changeset.
  - Removed: the comment that restated the next line in `intrinsics.js`, the inline comment on the `Parcel:` table key, and the field comment in `parcel.types.d.ts`.
  - Duplicate fixture and test comments are cut to one copy. The `_parcel-shim-*` and `_parcel-no-locate`/`_parcel-non-function` file headers are shortened.
- **releaser / changeset-auditor:**
  - `.changeset/ses-permit-parcel.md` is now three lines: what is new, what breaks, and how to upgrade.
  - I kept the `major` bump. Earlier versions left an unrelated `globalThis.Parcel` alone, and `lockdown` now throws for it.
  - That justification, plus decomplector's requested sentence on why the `URL` taming pattern cannot live wholly inside `@endo/parcel` (only SES fills in child-compartment globals), is in the new PR description.

**Verification:**
- Locally: `yarn lint:types` passes, `yarn test` passes (425 passed, 1 known failure, 2 skipped), and eslint and prettier are clean on the files I changed.
- XS could not run on this host because the `xst` binary is broken. CI covers XS and is green.

**Follow-ups:**
- **PR description not yet updated.** The current one still describes the retired SturdyRef design. This host's bot token got a 403 on `gh pr edit` for endojs, so I posted job `endojs-endo-but-for-bots-pr1391-body-refresh`, pinned with `requires: host=endolin-garden-ece02cb4`, carrying the full replacement text. The bump justification and the `URL` sentence only appear once that job runs.
- **Not done:**
  - decomplector must-fix 1: removing the sample/validate/tame chain in favor of a shim-owned attenuated constructor. That redesign also changes `@endo/parcel`, which is already built to cooperate with SES deriving `%SharedParcel%`. I answered it with the PR-description sentence the reviewer offered as the alternative.
  - decomplector should-fix 3: lockdown rewriting `prototype.constructor` on the shim's prototype.
  - The panel may raise either again in panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3263243 cached reads)
- Output: 19151 tokens
- Cost: $1.8988685999999997
- Wall-clock: 2738s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
