---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split
handler-timeout: 7800
split-indivisible-reason: 'remaining work is one atomic verify-and-report step on already-pushed head f66740e9ba (code fixes done; only CI completion wait plus one summary comment remain)'
split-lineage-root: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027
split-lineage-parent: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: producer
posted_at: 2026-10-27T14:14:15Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Finish `endojs/endo-but-for-bots` PR #1349 (`build/hardened-text-codecs-shim`): verify head `f66740e9ba17f2f048bbbed0bdbbc4c63c1e775a` and post the top-level review-follow-up summary comment. The code work is already pushed. Do NOT re-implement it.

Commits already pushed by the parent job (on top of peer head 4c315e84c0), addressing should-fix items left open by panel review 5648010120:
- `3ba36d2c9e` (prover 1): the "present as native functions" test in `packages/ses/test/text-encoder-decoder.test.js` now asserts `TextEncoder !== initialTextEncoder` (and the decoder too). Before this, it passed with `tameTextCodecs()` reverted. Verified: it fails with the call commented out, and it fails when `markVirtualizedNativeFunction(obj)` in `src/permits-intrinsics.js:266` is removed. That marking is where the native presentation comes from (spec-keeper 2).
- `62f3e263f3` (spec-keeper 1): new test pins the `length`/`name` (`{writable:false, enumerable:false, configurable:true}`) and `prototype` (non-configurable) attributes. The JSDoc now names all three attributes. Verified: the test fails if `name` is made writable.
- `f66740e9ba` (engine-realist 1): `packages/ses/test/_xs.js` now asserts that xst provides both codecs, and drops the presence guards. The absent path stays in `_xs-missing-text-codecs.js`. Verified: deleting `TextEncoder` before the assertion throws `RangeError: xst provides TextEncoder`.
Local results after rebasing: `yarn workspace ses lint` clean; `yarn test` 549 passed, 2 known failures, 2 skipped; `test:xs` passes; garden probes-only pre-push gates pass (10 stages).

Verified, no change needed:
- prover 2: forwarding a second argument through the public `repairIntrinsics` turned that test red. The peer commit `39d901ae68` has since deleted the test and reworked the hook.
- migrator 2: subclassing is already pinned at `text-encoder-decoder-restricted-properties.test.js:163`.
- breaker 1 and migrator 5: the `SES_MULTIPLE_INSTANCES` check (`seemsToBeLockedDown`, `src/lockdown.js` ~337) runs before `tameTextCodecs()`. A second SES copy after a completed lockdown therefore hits the existing error first. The new TypeError fires only for a prototype frozen before lockdown, which an idempotence guard would not fix. An earlier maintainer direction (r4214703715) calls redundant-replacement guards overkill.

Left unresolved on purpose:
- spec-keeper 3, whether to gate on the restricted `caller`/`arguments` feature-detect: this is @naugtur's open conditional-taming thread on `packages/ses/src/lockdown.js` (the reply in review 5665535461). Leave it for the maintainer and do not change the code.

Steps: (1) Wait in a bounded foreground loop until all 16 checks on f66740e9ba (or the current head, if a peer has pushed) complete. At the parent's last look, 15 were green and `test (22.x, macos-15)` was in progress. A macOS `restore-context`/cli exit-leak red is a known cross-PR flake, so rerun it with `--failed`. (2) Post one top-level PR comment in the house "**Review follow-up** · CI: … · next: maintainer re-review" shape, listing the above. (3) Do not re-request review from the bot itself.
