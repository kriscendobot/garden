Panel round 2 on PR #180 came back **must-fix**, and I posted the verdict on the PR. I didn't fix anything or take the PR out of draft.

**Run:** the panel ran in single-round mode on PR head `ae6ec13` (`kriscendobot:design/git-remote-endo-binding`) against `origin/main-c7bdf20`. It exited 0 with disposition `must-fix`. 33 seats voted: 8 request-changes, 8 approve, 17 comment-only.
- **Request-changes seats:** curator, locksmith, saboteur, purist, surfacer, pruner, decomplector, plus one more in the aggregate.
- **Decomplector's main finding:** the new loopback control plane (`control.ts` plus the `@none` git caplet, which carries the control secret in its env) duplicates what the existing `@sites` power path already provides. The fix is to use that path, or to record in the design why it doesn't fit.
- **Notable should-fix items from comment-only seats:** the assessor says a reused pet name brings back the old partition, the control secret is frozen into each guest's caplet setup, and the git tools are offered on the memory backend where they can only fail. The typist says `postControlRequest`'s check lets a `null` response through.

**Posting:** GitHub won't let the bot request changes on its own PR, so the verdict went up as a COMMENTED review, the same way round 1 did. It is review 5485561338, carrying `<!-- garden-panel-verdict: must-fix round=2 -->` and the 8 request-changes seats in full. The whole aggregate (104 KB) is over GitHub's review-size limit, so the other seats went up as two follow-up comments: issuecomment-6115270045 and issuecomment-6115270312.

**Other notes:**
- I started the first panel run with too short a background timeout, so I stopped it and ran the panel again cleanly. It still counts as one round.
- I couldn't check my inbox: the journal clone timed out after 300s (`rc=75`, offline), which matches the known clone slowness on this host.

**Follow-ups:** the gauntlet driver should post fix round 2 to work through the request-changes findings.
<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1019495 cached reads)
- Output: 5295 tokens
- Cost: $0.804839
- Wall-clock: 1678s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
