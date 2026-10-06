**Gauntlet viability: endojs/endo-but-for-bots PR #1428**, "chore: get upstream master 356d6e7 CI green". Verdict: **proceed**.

The check finished last session and its findings stand. It ended with the result marker after the completion signal, so the signal wasn't on the last line and the job came back. This report puts the signal last.

**PR facts:**
- The PR is OPEN, not merged, and still a draft.
- It merges `fix-upstream-master-ci` (head `e1279b7939`) into `master-356d6e7`, a frozen copy of upstream `endojs/endo` master at `356d6e7`.

**Deciding question:** Is upstream `endojs/endo` master still at `356d6e7` and still failing `lint`, `viable-release` and `test (22.x, macos-15)`, with no newer fix that displaces this PR?

**Answer:** Yes on both counts. The PR has not been superseded, and the problem it fixes still exists.

**Evidence:**
- **Upstream has not moved.** Comparing `356d6e7...master` on `endojs/endo` shows 0 commits ahead.
- **Upstream is still red on the same checks.** Upstream master's failing check runs are exactly the three checks this PR targets.
- **No competing fix exists.** No open upstream PR touches the hardened-mode `yarn.lock` resolutions, or the problem where `git clean -fX` deletes `.yarn/install-state.gz`. Among fork PRs, #847 ("chore(ci): establish current master baseline") is an older, separate effort and does not cover these fixes.
- **The fork branch is green.** The PR's own comment reports green CI at `e1279b7939` (run 37408899643).
- **There are no reviews yet.** The work is unreviewed, which is what the gauntlet is for.

I made no changes and spent no clean, panel, fix or CI-wait budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (213392 cached reads)
- Output: 2259 tokens
- Cost: $0.847326
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
