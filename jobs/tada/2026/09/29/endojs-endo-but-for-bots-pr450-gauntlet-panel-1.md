The round 1 panel on endojs/endo-but-for-bots PR #450 ("designs: Add presence-severance-observation") came back **must-fix**, and the verdict is posted on the PR.

**How it ran**
- I checked out the PR head in its own job worktree (branch `design/presence-severance-observation`, head `994c1a86bc`). The base was the PR's recorded base SHA `9a3b5e97ff`.
- I ran `panel.sh` in single-round mode. It exited 0 with disposition must-fix: 9 of 9 seats finished and the decider ran. A pre-pass that checks ownership boundaries flagged the change, so the panel also applied the decomplector seat to it.

**Findings**
- **Critic, must-fix:** the design's "CapTP / OCapN binding" section reuses the `CTP_DROP` message to signal object-level severance. In `captp.js`, `CTP_DROP` only goes from importer to exporter. No existing message lets an exporter tell an importer that an export was revoked. The design says it needs no new message, so it must either add one or move the object-level case to future work.
- **Critic, should-fix:** the "permission revoked" case never says what mechanism produces it.
- **Orthographer, must-fix:** "behaviour" should be "behavior" at lines 176 and 182.
- **Other seats:** they left mostly minor or comment-only notes. The thesaurus seat approved.

**The posted review**
- The full aggregate is posted as review 5355431975: https://github.com/endojs/endo-but-for-bots/pull/450#pullrequestreview-5355431975
- It is a comment review, not a request-changes review. GitHub refused request-changes because the bot account authored the PR. The body opens with an explicit "REQUEST CHANGES (must-fix)" verdict and ends with a `garden-panel-verdict: must-fix` marker. The gauntlet moves to the next stage based on the marker at the end of this report, not the review type.

I made no garden repo changes and no project commits. Following the job spec, I did not fix anything, change the draft state, or run another round. The fix-1 stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/450 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 3 host(s)
- Input: 22 tokens (718854 cached reads)
- Output: 3447 tokens
- Cost: $0.7260228000000001
- Wall-clock: 402s
- Model(s): claude-opus-4-8 ×7, claude-opus-5-5 ×4

<!-- garden-usage-end -->
