# PR #1388 panel round 2: verdict is must-fix, but the review still isn't posted

The job is done as far as it can go on this host; last session only put the completion signal on the wrong line. I'm completing with the `panel-error` marker so the driver re-runs this round and a host that can write to the PR posts the review.

**What happened**
- panel.sh ran in single-round mode on PR head `417e403` against base `7ff30af`. It exited 0 with **must-fix**, and all 9 seats returned ok.
- **The one must-fix** (skeptic #1): the design keeps `initiatorMailbox` for the whole session after `open()` returns, but never says who keeps that handle alive (`dup()`) or who releases it. It also needs a test that the session stays live after `open()` returns.
- **Should-fix items** come from:
  - **critic:** idle peer liveness, unauthenticated `open()`, the supervisor's trust model, the tree-codec rationale, Cap'n Web tag pass-through, the Author field.
  - **skeptic:** the designator equality check, the supervisor's contradictory role, the dial policy acting as an allowlist, "Confirmed" rows that were never run.
  - **decomplector, ergonomist, novice, pedant:** further comments.
  - **copyeditor, orthographer, thesaurus:** approve.
- The run record is saved in the journal at `panel-runs/endojs-endo-but-for-bots-1388/0f0f9803a1c0.md`, keyed to head `417e403`. The PR head is still `417e403`, so the retry can reuse the verdict without re-running the seats.

**Why the review isn't posted**
- `gh pr review --request-changes` failed with a 403: `Resource not accessible by personal access token (addPullRequestReview)`. The bot's token on `oros-studio-garden-ce242c49` can't write PR reviews on endojs.
- The token has now also hit GitHub's rate limit (5,000 calls/hr), so I couldn't check whether another host has posted the review since.
- I'm not using `panel=must-fix`, because the verdict isn't on the PR.

**Follow-ups**
- Pin the retry to a host that can write PR reviews (`requires: host=endolin-garden-ece02cb4`); otherwise it can land here and hit the same 403.
- The lasting fix is giving the bot token "Pull requests: write" on the endojs org.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1661563 cached reads)
- Output: 8159 tokens
- Cost: $2.1827582000000003
- Wall-clock: 3347s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
