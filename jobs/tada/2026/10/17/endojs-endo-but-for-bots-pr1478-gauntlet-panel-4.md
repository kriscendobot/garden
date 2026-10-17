I ran panel round 4 on PR #1478 and it came back **must-fix**. I posted the verdict to the PR.

- **Run:** `panel.sh` in single-round mode, against an isolated checkout of `endojs/endo-but-for-bots@build/ocapn-noise-session-queue` (head `c4bf0a40b8`) with base `origin/build/ocapn-noise-session-reconnect-heartbeat-9175a5b` (`9175a5b5bb`). It exited 0 with disposition `must-fix`.
- **Seats:** 34 in total: 4 request-changes, 20 comment-only and 10 approve. The request-changes seats were saboteur, pruner, orthographer and decomplector.
- **Main findings for the fixer:**
  - **decomplector** (two must-fix items):
    - Asks whether the session outbound queue, the high-water mark and `spaceWaiters` are needed at all. It argues that a serialized `writer.next` chain with a stall timer, plus skipping the heartbeat tick while a write is in flight, gives the same backpressure. If the maintainer wants the queue for reconnect, the PR should say so.
    - `sentCount` and `lastSentNonce` duplicate the cipher's nonce state.
  - **saboteur** (should-fix items):
    - A bad frame from one writer call now kills the whole session.
    - A drain stuck on a hung `writer.next` is never released.
    - A writer waiting for room can race with `return()`.
  - **pruner:** the PR body is 394 words, over the ~300-word threshold, and several test comments only restate the code or assertion next to them.
  - **orthographer:** request-changes on spelling; I didn't extract its specific items.
- **Posted:** a comment review on the PR, review 5555636476. GitHub won't let the bot request changes on its own PR, so the comment form matches rounds 1–3.
  - The body lists all request-changes and comment-only seats in full. To stay under GitHub's 65,536-character limit, 12 seats are named but their text is left out: corner-prober, fast-checker, releaser and coverage-auditor (all comment-only), plus 8 approvals.
- **Repeat issue:** this is the fourth must-fix round in a row on the same mechanism, so the panel added the decomplector's "is it needed" question. Someone may need to decide whether the queue stays before another fix round runs.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (942510 cached reads)
- Output: 4432 tokens
- Cost: $0.7719260000000001
- Wall-clock: 217s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
