Clean stage finished. Writing the completion report now.

## Completion report — gauntlet clean stage, endojs/endo-but-for-bots#1391

**Idempotence check:** PR #1391 (`feat(ses): permit and share a pre-lockdown SturdyRef shim`) was draft/OPEN with CI mostly SUCCESS but one `test (22.x, macos-15)` leg still IN_PROGRESS — not yet terminal, so the clean stage was not a no-op.

**Isolated checkout:** Obtained via `ensure-project-worktree.sh` against `endojs/endo-but-for-bots` @ `build/sturdyref-ses-accommodation` (head owned by `endojs`, not a fork).

**Coverage pass (packages/ses, packages/sturdyref):**
- Ran `yarn cover` on `packages/ses`: 413 passed, 1 known failure, 2 skipped; 79.56% overall statement coverage.
- Diffed the PR's touched files (`global-object.js`, `intrinsics.js`, `lockdown.js`, `permits.js`) against the frozen base `ef4662f04b` and cross-referenced each against the coverage-final.json uncovered-line list.
- Every line the PR actually added — `firstWinsPropertyNames`/`isFirstWinsDescriptor` in `global-object.js`, `assertSturdyRefShape` in `intrinsics.js`, its call site in `lockdown.js`, and the new `SturdyRef`/`%SturdyRefPrototype%` permit entries — is fully covered. All remaining uncovered lines in those files are pre-existing, unrelated code (Hermes `strict`-mode TODO, misconfiguration-guard throws, etc.) outside this diff's scope.
- Ran `yarn ava` on `packages/sturdyref`: all 22 tests pass, including the tightened `sturdyref-prelockdown.test.js` assertion this PR modified.
- No dead code was orphaned by this change; nothing met the four-criterion "dead" threshold.

**Result:** No code changes were needed, so nothing was pushed to the PR head.

**CI watch:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh endojs/endo-but-for-bots 1391 --no-merge` — the pending macos-15 leg completed after ~17 minutes; terminal rollup `total=33 failed=0 → CI GREEN`, rc=0.

**Follow-ups:** None. PR remains draft (un-drafting is the panel stage's job, not clean's).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 122 tokens (4889214 cached reads)
- Output: 18751 tokens
- Cost: $2.1082488
- Wall-clock: 4985s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
