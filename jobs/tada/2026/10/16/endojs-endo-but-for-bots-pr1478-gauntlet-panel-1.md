I ran panel round 1 on endojs/endo-but-for-bots PR #1478 (session outbound queue and stall fault injector, session-reconnect Phase 2), and the verdict is **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error.

- **Setup:** I made an isolated checkout of `build/ocapn-noise-session-queue` at head `11664d0e4f` and ran single-round mode. I passed the PR's real merge-base SHA `9175a5b5bb` as the base instead of the bare branch name.
- **Seat results:** 33 seats ran. 5 asked for changes (assessor, typist, saboteur, breaker, pruner), 20 were comment-only and 8 approved. A check on the PR description's length fired, so the pruner also reviewed the description.
- **Main findings from the assessor:**
  - A frame can sit in the outbound queue until the next heartbeat when it arrives just as the drain loop finishes.
  - The outbound queue has no size limit, and `writer.next` no longer applies backpressure.
  - The documentation for `lastSentNonce` doesn't match how `sentCount` is counted.
- **Typist must-fix:** the test file uses an inline `import()` type in a JSDoc `@param`; it should be added to the file's top-level `@import` block.
- **Posted as a comment review, not request-changes:** GitHub refused request-changes because the bot opened this PR. The review's header line says the verdict is must-fix: https://github.com/endojs/endo-but-for-bots/pull/1478#pullrequestreview-5553176483
- **Split across two posts:** the full panel output (86 KB) is over GitHub's limit for a review body. The review holds the header, the 5 request-changes seats and 13 others. The other 15 seats are in a follow-up PR comment: https://github.com/endojs/endo-but-for-bots/pull/1478#issuecomment-6223842436

Possible follow-up: on bot-authored PRs a request-changes review is always refused. `scripts/jobs/gauntlet.sh` (the panel-stage job text) could say to post a comment review in that case. The posting step could also split output that's too long for one review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1478-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1116194 cached reads)
- Output: 5918 tokens
- Cost: $0.8113667999999998
- Wall-clock: 181s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
