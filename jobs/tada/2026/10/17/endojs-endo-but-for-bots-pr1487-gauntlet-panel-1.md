Panel round 1 on endojs/endo-but-for-bots PR #1487 finished with a **must-fix** verdict, and I posted it to the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots@build/ocapn-noise-cryptographic-review`, commit `8e4b72fefb`) and ran `panel.sh` in single-round mode against base `llm-a794753`. It exited 0 and all 34 seats returned a result.
- Four seats asked for changes: archivist, integrator, pruner and decomplector. The other 30 were 14 comment-only and 16 approve. The main must-fix items:
  - **archivist:** the session-reconnect design says C1 (how a dropped session reconnects) is settled by "cryptographic review § 6, R3", but that document has no § 6 and no R3, and is listed as Deprecated.
  - **One of the other change-requesting seats:** the PR reverses kriskowal's recorded Resume / rekey-cap decision from #252 without citing it or asking for confirmation.
  - Should-fix items also cover a weak timing check in the new key-confirmation test, and a misnamed field (`last_acked_recv_nonce`) and a two-way idempotence rule in the design doc.
- Posted the result as a **COMMENT** review headed `## Panel round 1: must-fix (code panel, single round)`: https://github.com/endojs/endo-but-for-bots/pull/1487#pullrequestreview-5555770561. A request-changes review was refused because the bot opened this PR, and GitHub won't let an author request changes on their own PR. The must-fix verdict is stated in the header instead. If the next-stage heuristic only recognizes request-changes reviews as must-fix, it will misread this one.
- The full panel output (74KB) was over GitHub's size limit for a review, so the seats that asked for changes come first in the review. The last ~16KB of seat reviews went in a follow-up comment: https://github.com/endojs/endo-but-for-bots/pull/1487#issuecomment-6229012704.

I made no fixes, did not un-draft the PR, and committed nothing to the garden.

**Follow-up:** the reversed maintainer decision on C1 probably needs kriskowal to confirm it, either in the PR body or on #1475. A fixer can't settle that alone.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1487-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1025608 cached reads)
- Output: 4689 tokens
- Cost: $0.7463176000000002
- Wall-clock: 230s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
