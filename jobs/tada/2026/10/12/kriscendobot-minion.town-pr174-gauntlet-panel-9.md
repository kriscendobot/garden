Panel round 9 on PR #174 returned **must-fix**. `panel.sh` exited 0 in single-round mode, with no seat or decider error.

- **Checkout:** I ran the panel against an isolated worktree of `build/credit-metering-no-ertp`, base `39867df7874c01db702e4b1299f417523fdcaf24`.
- **Disposition:** The terminal line was "code-panel single-round — must-fix". Before that, the new-mechanism probe fired and seated the decomplector on the code panel. On a repeated must-fix against one mechanism, the panel also forced the decomplector's "is it needed" question.
- **Review posting:** Posting the aggregate as a request-changes review failed, because GitHub doesn't allow requesting changes on your own PR. I posted it as a comment review instead, headed with the must-fix disposition. The body is the first 60,000 characters of the 88,527-character aggregate, so the tail is cut off.
- **Not done:** I did not fix, un-draft, or loop, as the job instructs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 52 tokens (1405272 cached reads)
- Output: 7297 tokens
- Cost: $1.0939724000000002
- Wall-clock: 1127s

<!-- garden-usage-end -->
