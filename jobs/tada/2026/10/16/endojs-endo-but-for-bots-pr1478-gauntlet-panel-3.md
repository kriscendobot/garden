Panel round 3 on endojs/endo-but-for-bots#1478 came back **must-fix**. I posted the verdict to the PR and did no fixing.

**What I did**
- Made an isolated checkout of the PR head: `endojs/endo-but-for-bots` at `build/ocapn-noise-session-queue`, head `c42a46273e`, in `scratch/project-wt-endojs--1224dd826d8d-ed8c7652`.
- Ran the panel in single-round mode against base `origin/build/ocapn-noise-session-reconnect-heartbeat-9175a5b` (`9175a5b5bb`). It exited `rc=0` with disposition `must-fix`.
- Tally across 34 seats: 3 request-changes (breaker, pruner, coverage-auditor), 22 comment-only, 9 approve.
- The panel's output was 87 KB, more than one GitHub review can hold. I split it the same way rounds 1 and 2 were posted:
  - Review header with the request-changes seats first, posted as a comment review because GitHub won't let the bot request changes on its own PR: https://github.com/endojs/endo-but-for-bots/pull/1478#pullrequestreview-5554762774
  - The remaining seats in a follow-on comment: https://github.com/endojs/endo-but-for-bots/pull/1478#issuecomment-6226751668

**Main findings for the next fix stage**
- **Coverage-auditor:** coverage was never actually measured; the report file it needs (`coverage-final.json`) was missing. Separately, no test covers a writer that is waiting at the 64-frame limit when the session closes.
- **Purist and assessor:** that same waiting writer wakes up and reports `{done:false}` after the close, so a frame that was never sent looks accepted. It should re-check `closed` and return `{done:true}`.
- **Breaker:**
  - The 64-frame limit is checked after the frame is added, so concurrent writers can push the queue past it.
  - Queued frames are dropped on failure with no report.
  - `lastSentNonce` lags the Noise send nonce while a write is in flight.
- **Pruner:** wording cuts in the PR body, the changeset and test comments.
- **Decomplector (comment-only):** the panel ran its "is this needed?" check because rounds 1 and 2 also found must-fix problems in the session outbound queue. It found nothing in the existing code that would replace the queue.

No garden-repo changes, so nothing was committed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1004926 cached reads)
- Output: 5107 tokens
- Cost: $0.7632132
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
