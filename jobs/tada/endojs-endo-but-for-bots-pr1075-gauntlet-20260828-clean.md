CI reached a terminal GREEN state (24/24 checks, 0 failed). 

The clean stage for this PR is a no-op on content: PR #1075 is a purely additive test-only change to `@endo/hardened262` (one new test file `test/intrinsics/AsyncFunction/intrinsic-metadata.js` + baseline `passed.txt`/`skipped.txt` entries, +127/−0, no product source touched). There is no orphaned code to remove and no product-package coverage gap to fill — the change itself *is* the coverage. So the stage reduces to driving CI green, which it now is.

## Completion report

**Stage:** clean — endojs/endo-but-for-bots PR #1075 (gauntlet endojs-endo-but-for-bots-pr1075-gauntlet-20260828).

**What I did:**
- Verified PR shape: draft, OPEN, MERGEABLE, head `65e6a968`.
- Assessed content: test-only, strictly additive change to `@endo/hardened262` (adds `%AsyncFunction%` intrinsic-metadata coverage + regenerated baselines). No product source touched → no coverage pass to run and no dead code orphaned. Nothing to push.
- Drove CI to terminal via `ci-wait-merge.sh … --no-merge`: **rc 0, CI GREEN**, 24/24 checks, 0 failed (final pending check `lint` completed successfully).

**What changed:** nothing — no follow-up commits were needed (clean was a no-op on content).

**Follow-ups:** none. Stage complete; the gauntlet driver can advance to the next stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1075-gauntlet-20260828-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 19 tokens (499041 cached reads)
- Output: 3658 tokens
- Cost: $0.7805584999999999
- Wall-clock: 312s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
