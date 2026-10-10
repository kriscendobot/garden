Fix round 5 for endojs/endo-but-for-bots PR #1435 ("design: plan Moddable SDK 10.0.0 IronHorse ports") is pushed and CI is green.

**Must-fix from the panel-5 review:** the panel had one must-fix item. The pedant flagged the heading `## Release classification` as sentence case when the rest of `designs/` uses title case. The pedant was partly wrong: the plan used sentence case for nearly all its headings, not just that one. Fixing only the flagged line would have left the document inconsistent, so I title-cased all 14 headings, including the title. I also updated the `§` cross-references inside the document to match, including ones split across a line break.

**Comment-only item also fixed:** the critic noted a stale count. "Child 6 must measure all six children's code together" now reads "all five ports' code".

**Commit:** `83c690ab8`, changing only `designs/moddable-10-0-0-ironhorse-port-plan.md` (24 lines changed, 24 removed). It was pushed with `safe-push-pr-head.sh --mode advance`, moving the head from `c05ddcc0a` to `83c690ab8`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0. All 28 checks passed with no failures, after about 11 minutes.

**Left for later:** none of these were must-fix, and I didn't apply them:
- The critic's point that the README needs a milestone and size entry already appears to be done (there are entries for the M11 milestone, the dependency graph, and the size estimate).
- Still open as suggestions:
  - The critic's two other should-fix items: the reasoning for rejecting an early drift report, and how child 6 is re-promoted after its self-check fails.
  - The skeptic's three: what lets child 6 start when a port child stops or ends no-go, how intended oracle differences interact with the ratchet floor, and running each port's values once against a throwaway 10.0.0 `xst`.
  - The decomplector's: two writers for the expectation rows.
  - The novice's: introducing the children earlier, and table cells that are too dense.
  - The other copyeditor and ergonomist comments.

**Host problems on oros-studio:**
- The project checkout timed out at the 120s git limit and only succeeded with `GARDEN_REPO_GIT_TIMEOUT=900`, as already recorded in memory.
- The inbox drain was skipped because the journal clone timed out (rc=124), so I did not read any inbox messages.
- One GitHub REST call hit "API rate limit exceeded" once, and a retry succeeded.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1036896 cached reads)
- Output: 6900 tokens
- Cost: $0.8249392000000002
- Wall-clock: 1861s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
