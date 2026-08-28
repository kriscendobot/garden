All 24 CI checks pass — CI is fully green on my fix commit `40b328610`.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #1075 (`test(hardened262): cover %AsyncFunction% intrinsic metadata`).

**Panel must-fix applied:** The panel (`corner-prober`) gated on one item — the file's prose claimed lockdown "tames the async-function constructor into an inert stand-in," but no assertion exercised that behavioral contract. I added a lockdown-gated pair of `assert.throws` (call and construct) to `packages/hardened262/test/intrinsics/AsyncFunction/intrinsic-metadata.js`, keyed off `Object.isFrozen(AsyncFunction)` so the throw-on-invoke claim is covered in the lockdown scenarios and stays inert in the plain-`module` scenario where the native constructor is legitimately callable. I also folded in the panel's should-fix #2 — a `%AsyncFunction% !== %Function%` distinctness check — since it holds in both scenarios and directly catches a taming bug collapsing the stand-in onto the tamed `Function` intrinsic. (Advisory #3 async-class-methods, #4 ungated frozen-prototype, and the comment-only items were left as tracked sibling-pattern gaps, per single-round scope.)

**Real-execution evidence:** `node scripts/test.js` — `# ok` on `module` and `lockdownModule` across all three agents (`xs`, `sesXs`, `sesNode`); every other scenario correctly skipped. (An initial `sesXs` failure was a stale XS prelude; `yarn build` regenerated it and all passed.) Scenario pass/skip membership is unchanged, so the checked-in baselines needed no edits — the commit touches only the test `.js` file.

**Push:** Committed `40b328610` and pushed as a review-feedback follow-up to the PR head `test/hardened262-asyncfunction-intrinsic-metadata` via `safe-push-pr-head.sh` (advance mode).

**CI:** Watched to terminal — all 24 checks GREEN, including the load-bearing `test-xs` job that runs the hardened262 baseline comparison.

**Follow-ups:** None required for this stage. The driver re-posts panel-2. Advisory items #3/#4 and the header-comment `.length` self-contradiction (a copy-paste from the two sibling files) remain as house-template gaps worth back-porting across the three `*Function/intrinsic-metadata.js` files, if the maintainer wants them tracked.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1075-gauntlet-20260828-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 68 tokens (2375922 cached reads)
- Output: 17950 tokens
- Cost: $2.367377
- Wall-clock: 412s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
