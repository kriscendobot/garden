Panel round 5 on kriscendobot/minion.town PR #173 finished with a **must-fix** verdict. The review is posted on the PR as a comment, not a request-changes review.

- **Panel run:** I ran `panel.sh` in single-round mode on an isolated checkout of `design/ocap-site-crawler-leak-rotation`, against the frozen base `main-50aa690`. It exited 0 and its final line was `design-panel single-round — must-fix`.
- **Two seats added by the pre-checks:** the ownership-map check came back ATTENTION, and the same mechanism has drawn must-fix verdicts in repeated rounds. Both added the decomplector seat to this round.
- **Main finding (critic):** the design still describes rotation behaviors that the scope cut deferred, in parts it presents as committed:
  - the "rotate" tier in § 2 and the § 3.4 gate 5 count
  - the rotate-on-one-fetch rule and its grace window in § 4.2
  - the `rotating`, `cooling` and `rotatedFrom`-style states and fields in § 7.1's `LeakState` and `Status` types
  - the § 7 ownership table's rotation intents and rotation saga

  The critic also flagged that the measurement gate has a cost the design only partly acknowledges.
- **Why a comment:** GitHub rejected the request-changes review because the bot can't request changes on its own PR. I posted the same panel output as a comment review, with a first line reading "Panel verdict (round 5): must-fix". The full output is in `/tmp/panel173r5/round-1.md`, which is outside the job worktree and may not be kept.

Follow-ups: the fix loop should next remove or mark as deferred the rotation material listed above. If the next-stage check only looks for a request-changes review, it may miss this comment-form verdict on bot-authored PRs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (227134 cached reads)
- Output: 1510 tokens
- Cost: $0.4215068
- Wall-clock: 130s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
