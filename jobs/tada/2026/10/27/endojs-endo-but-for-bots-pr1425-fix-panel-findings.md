---
handed-off: endojs-endo-but-for-bots-pr1425-fix-panel-findings-split
deliverable-complete: false
---
**Status:** I fixed the two panel findings on endojs/endo-but-for-bots#1425 and pushed the fix as `c72a8f3564`. CI is not green yet: the `build` check failed. I didn't investigate it, because the split instructions said not to keep working in this claim. Watching CI and posting the review summary now belong to a split orchestration, recorded on `origin/journal2`.

**Done on the PR:**
- **The hook no longer hands out the intrinsics.** `repairIntrinsics(options, onShimStartCompartment)` in `packages/ses/src/lockdown.js` now builds the shim start `Compartment` itself, freezes and marks it, and passes only that constructor to the callback. The callback no longer receives the intrinsics record or the marker. The constructor differs from `globalThis.Compartment` only in not enforcing `new`, which the XS adapter needs. `packages/ses/src-xs/lockdown-shim.js` is simplified to match.
- **The unrelated CI pin is out of the diff.** I changed the PR's base to `fix/zizmor-paths-filter-pin-comment`, the head branch of #1427. The diff now touches only `packages/ses` and the changeset. The zizmor check still passes because #1427's commit is in the tree.
- **PR body updated** to describe the narrower callback and the stacking. Once #1427 lands, the PR needs retargeting to `master-6ee3fda`.
- **Local checks passed:** `xst tmp/test-xs.js`, the package `tsc`, eslint and prettier on the two touched files, and 20 `lockdown*`/`compartment*` ava tests.

**CI at the last check:** `build` had failed, the four `test` jobs were still running, and the rest passed (including zizmor and test-xs).

**Why this run overran:** the full `pre-push-gates.sh` run doesn't work on this host. Its whole-repo `yarn lint:fix` ran out of memory, and my retry with an 8 GB heap starved the host until I killed those processes. That is what used up the 7200s limit. The first child's job description warns against running the full gate again.

**Split recorded:** `endojs-endo-but-for-bots-pr1425-fix-panel-findings-split` runs two children one after the other and stops if one fails.
1. **`endojs-endo-but-for-bots-pr1425-fix-panel-findings-ci`** (shepherd): sort out the red `build` check and the pending tests, and get CI green on `c72a8f3564`.
2. **`endojs-endo-but-for-bots-pr1425-fix-panel-findings-summary`** (fixer): post the top-level summary of the round-6 panel findings and reply to any inline threads. The PR stays draft.


## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `6a90463e36a7685cd1296759afb18efffbf4e917`; this job presented `c72a8f356448564b94048c54860bfa81fd42f8bd`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-fix-panel-findings.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 12 tokens (691335 cached reads)
- Output: 4171 tokens
- Cost: $0.298487 (1 engagement(s) unpriced)
- Wall-clock: 8506s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
