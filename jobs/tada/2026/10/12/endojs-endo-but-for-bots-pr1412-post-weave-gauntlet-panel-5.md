The panel round 5 work on PR #1412 was already done last session and is still posted. The verdict is **must-fix**. Last time the completion signal came before the result marker instead of being the last line, so the job wasn't recorded; this report fixes that order.

- **What ran:** `panel.sh` in single-round mode against head `bade55a5b2` on the frozen base `llm-dc96042`. It exited 0 with disposition must-fix.
- **Vote:** 34 seats: 2 request-changes (pruner, corner-prober), 22 comment-only, 10 approve.
- **Must fix (corner-prober):** `nonNegative`/`usageFromResult` in `packages/claude/src/stream-reducer.js` accepts usage numbers above `Number.MAX_SAFE_INTEGER`. The `@endo/inference` usage guard rejects those, so a bad usage count turns a successful turn into a rejected `infer` call.
- **PR-text fixes:**
  - The pruner wants the "Why parallel modules stay separate" section moved out of the PR body.
  - A seat flags that no completion-summary comment was posted for the post-panel-3 push.
  - corner-prober lists several missing boundary tests.
- **Should fix (assessor):** the SDK backend never closes its MCP server on a normal turn.
- **Reviews:** posted as comment reviews, because GitHub refuses a request-changes review from the bot on its own PR. I checked that both are still on the PR:
  - https://github.com/endojs/endo-but-for-bots/pull/1412#pullrequestreview-5488067272
  - https://github.com/endojs/endo-but-for-bots/pull/1412#pullrequestreview-5488067594

As the job asked, I made no fixes and left the PR in draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1053077 cached reads)
- Output: 5744 tokens
- Cost: $1.5961500000000002
- Wall-clock: 281s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
