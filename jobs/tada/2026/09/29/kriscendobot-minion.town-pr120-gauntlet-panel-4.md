## Completion report: kriscendobot/minion.town PR #120, gauntlet panel round 4

**Verdict: must-fix.** I ran one panel round, posted the verdict and stopped. I made no fixes and did not un-draft the PR.

**What I did**
- **Checkout:** made an isolated checkout of the PR head (`kriscendobot/minion.town` `claude-agents-delegate` at `eaebbf9`). It is at `scratch/project-wt-kriscen-bac959588d4d-52a202f6`.
- **Base:** used the PR's actual base commit `c8150415` (`main-c815041`), not the remote-tracking branch. The file list for `base...HEAD` matches GitHub's list for the PR (16 files).
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_YARN=npm panel.sh … 120 c8150415…` in a detached session. It exited 0: code panel, 33 seats, all `ok`, disposition `must-fix`. The run was recorded in the journal as `panel-runs/kriscendobot-minion.town-120/ddd51ede5125.md`.
- **Review posted:** review 5346876565 (state COMMENTED, because the bot owns the PR and GitHub won't let it request changes on its own PR). The body header says "disposition: **must-fix**".
- **Per-seat reports:** the full aggregate is 86 KB, too big for one review, so it went into two follow-up comments: issuecomment-5882318368 (part 1/2) and issuecomment-5882317412 (part 2/2). Part 1 went up second because the gh wrapper refused it at first for bare `#1015` references. I rewrote those as `endojs/endo-but-for-bots#1015` and reposted.

**Must-fix items**
1. **Probe gate blocks (can't be fixed in code).** A check that runs before the seats (the phase/evidence pre-pass) found that the governing design classes this PR as a probe that must stay draft: `designs/claude-agents-capability.md` production-sequence phases 1–6 lack evidence (endojs/endo-but-for-bots#1015 is unmerged and the canaries haven't run). This is the **fourth round in a row** blocked on this gate.
2. **A failed `create` can delete a child another call just published** (found by saboteur, reproduced; breaker agrees). When two `create` calls race on the same new name, the one that fails rolls back and removes the directory child and its quota slot, while the other call's agent is still live. That leaves live agents the pool cap and the delegation `maxChildren` limit don't count.
3. **`revoke` doesn't stop running agents right away** (wire-watcher). The liveness check in `makeClaudeAgent` never looks at `delegation.live`, so agents under a revoked grant keep answering until the teardown loop reaches each one.

The review body lists the should-fix and comment-only items. The round-3 code findings no longer appear at this head.

**Follow-up for the maintainer:** item 1 is a structural stop. Further panel and fix rounds on #120 can't reach `pass` until the production sequence lands. You may want to pause the gauntlet loop and keep #120 as a draft probe instead of spending more rounds on it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1217419 cached reads)
- Output: 7831 tokens
- Cost: $0.9240078
- Wall-clock: 460s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
