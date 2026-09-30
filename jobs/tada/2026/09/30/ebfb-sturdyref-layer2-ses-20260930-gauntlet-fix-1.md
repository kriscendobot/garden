I applied the panel's must-fix items to PR #1391 and pushed them. CI had not finished by the 3600s deadline (`ci-wait-merge` returned rc=4). The head `c78271e1f1` is 30 of 33 checks green with no failures. Three are still pending: `test (22.x, macos-15)`, `test (22.x, ubuntu-latest)` and `test (24.x, ubuntu-latest)`.

**Fixes applied** (all in `packages/ses`, pushed with `safe-push-pr-head.sh` as commits `b6cbc3ac0f`, `571b976bcd`, `c78271e1f1`):
- **Rename (stylist):** `desc` is now `descriptor` in `src/global-object.js` and in `test/sturdyref-shimmed.test.js`.
- **Skip scoped to `SturdyRef` (wire-watcher, breaker, spec-keeper, purist):** lockdown used to leave any locked universal global in place. It now does so only for names on an explicit allowlist, `firstWinsPropertyNames`, which holds just `SturdyRef`.
- **Full shape check:** the skip also requires the exact shim shape. That is a data property that is non-writable, non-enumerable and non-configurable, whose value is the intrinsic SES would install (compared with `is()`, like `initProperty`). Anything else falls through and lockdown throws, so a locked `JSON` fails loudly again.
- **Comments:** I reworded the child-compartment comment so it matches what the code does, and shortened the permit comment in `permits.js`.
- **Fail-closed tests:**
  - `test/global-locked-universal.test.js`: a `JSON` global locked before lockdown still makes lockdown throw.
  - `test/sturdyref-misshapen.test.js`: a locked but enumerable `SturdyRef` still makes lockdown throw.
  - I confirmed both throw `Cannot redefine property`.
- **XS coverage (coverage-auditor must-fix, engine-realist):** `test:xs` now also runs the stand-in shim, the SES bundle and a new `test/_sturdyref-xs-smoke.js` under `xst`. It checks that the start binding is kept, that the constructor and prototype are frozen, and that child and grandchild compartments share it. Run without the shim it fails (rc 1). The PR body explains why `packages/sturdyref`'s `test:xs` stays a stub: the real shim can't run before lockdown until layer 1 (#774) changes.
- **Changeset and PR body:** both now describe the narrowed scope and the new tests. I also applied some of pruner's trims to the body: I shortened the layer-1 section and the Scaling section and removed the inline test tally.
- **Lint fix:** the first CI run failed `lint:types` (TS18048, a possibly-undefined `descriptor` in the XS smoke script). I fixed it with optional chaining and re-pushed; `lint` and `test-xs` then passed in CI.

**Local checks:** the full `packages/ses` ava run passed (408 passed, plus the 1 known failure and 2 skipped that were already there). `packages/sturdyref` ava passed 22 tests. `yarn test:xs`, `lint:types`, eslint (no errors) and prettier were all clean.

**Follow-ups:**
- The driver should re-post this stage to finish the CI watch; after that, panel-2.
- Not done, as planned:
  - Pruner's suggestion to drop the "Stack index" section (another seat approved the section).
  - The fast-checker's property-test suggestions: one is marked follow-up and the rest summary-fix.
  - The breaker's out-of-scope note about the `newGlobalPropertyNames` loop.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3803159 cached reads)
- Output: 19003 tokens
- Cost: $1.9096997999999998
- Wall-clock: 6815s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
