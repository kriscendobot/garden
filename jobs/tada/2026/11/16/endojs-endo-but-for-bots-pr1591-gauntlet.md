I restarted the gauntlet for endojs/endo-but-for-bots PR #1591 at its viability stage instead of jumping ahead. The earlier review had found this PR covered by a competing one (#1542), and that hasn't changed.

**Where the PR stands:** #1591 is open, still a draft and mergeable on base `llm-48d6f3e`. CI is green on head `59f6b24875` (17 passed, 18 skipped). The 2026-11-15 weave and shepherd jobs got it there. It has no reviews.

**Why I didn't skip the viability check:**
- The earlier gauntlet record (2026-10-31) stopped at viability: it judged #1591 a duplicate of #1542, which fixes the same bwrap init-orphan bug in the same driver file.
- That report said to re-run #1591 only on an explicit "run the gauntlet #1591" ask, and only if #1542 is dropped.
- This job, the weave and the shepherd were all posted by the foreman, not the maintainer.
- #1542 has not been dropped. It is still open and out of draft, but its own gauntlet stopped at fix round 4 and it sits on an old base, `llm-d5ac419`.
- Bypassing the gate on the foreman's word alone seemed wrong. Re-running viability is cheap and lets the decision use current facts.

**What I did:**
- On the leader host I ran `gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1591-gauntlet viability`. It reported "accepted resume at viability (iteration 0)" and "restarted at viability".
- Checked on `origin/journal2`: the gauntlet record `jobs/gauntlet/endojs-endo-but-for-bots-pr1591-gauntlet.md` is active again, and the stage job `endojs-endo-but-for-bots-pr1591-gauntlet-viability` is in `jobs/todo/`.
- From here the gauntlet driver moves it forward. If viability passes, it goes on to clean, panel, the fix rounds and un-draft. If it finds #1591 overtaken again, it reports that with the deciding question and a "close as superseded" option.

I made no commits and did not post on the PR.

**Decision for the maintainer:** #1591 and #1542 are competing fixes for the same bug, and both are stuck. Picking one, either landing #1542 and closing #1591 or dropping #1542 and running #1591 through, would unblock the #1504 sandbox-shell work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (914064 cached reads)
- Output: 5510 tokens
- Cost: $0.8475568
- Wall-clock: 253s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
