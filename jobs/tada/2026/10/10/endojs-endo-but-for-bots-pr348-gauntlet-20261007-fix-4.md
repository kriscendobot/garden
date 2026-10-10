## Fix round 4 for endojs/endo-but-for-bots#348: round-4 must-fix items applied, CI green

I handled every item from the panel's round-4 review. The new PR head is `e38ce99781`, and all 15 CI checks pass (`ci-wait-merge` rc 0).

**Why the CI commit kept coming back:** the frozen base `master-6ee3fda` fails `zizmor` unless the `dorny/paths-filter` pin comment is fixed. That is why earlier rounds kept re-adding the `ci:` commit, and the panel kept rejecting it. PR #1427 (`fix/zizmor-paths-filter-pin-comment`) already makes exactly that change against `master-6ee3fda`, and its CI is green.

**What changed:**
- **Unrelated `ci:` commit (blocking):** I rebuilt the branch on top of #1427's branch without commit `4c26146932`, and changed #348's base to `fix/zizmor-paths-filter-pin-comment`. The PR diff now has no CI changes, and `zizmor` stays green. Apart from the changeset, the code is identical to the previous head. I pushed with `safe-push-pr-head.sh --mode rewrite`.
- **Changeset pair (should-fix):** I squashed `b80f58474a` and `ff85e2b4b5` into one changeset commit, `945c5721ac`.
- **Generated runtime (should-fix):** the changeset now says that `makeBundle` output text changes slightly but behaves the same.
- **`src/bundle.js` public API (must-fix/should-fix from migrator, purist and surfacer):** I checked `package.json` `exports`. `./bundle.js` points to the root file, which re-exports only `makeBundle`/`writeBundle`, and there is no `./src/*` entry. The PR body now states that `src/bundle.js` is not public API.
- **PR body length (summary-fix):** cut from 422 to 224 words. It now has a "Depends on #1427" line and a note to retarget to `master-6ee3fda` once #1427 merges.
- I posted a completion-summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/348#issuecomment-6100339327

**Follow-ups:**
- #348 cannot merge to `master-6ee3fda` until #1427 merges. After that, #348 has to be retargeted back to `master-6ee3fda`. GitHub does this automatically only if the #1427 branch is deleted on merge.
- Panel-5 will see the new base, `fix/zizmor-paths-filter-pin-comment`. Its diff should show only the compartment-mapper work.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1143569 cached reads)
- Output: 7547 tokens
- Cost: $0.9337018
- Wall-clock: 652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
