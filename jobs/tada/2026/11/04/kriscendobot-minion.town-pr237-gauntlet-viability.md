**Viability verdict for kriscendobot/minion.town PR #237: proceed**

PR #237 ("test(claude): poll the mailbox in the guest-pinned responder restart test") is open, unmerged and still a draft. It changes only `test/endo-daemon-integration.test.ts` (+15/−6). Head `b942fb97` is on base `main-9196892`, the frozen snapshot of `main` at `91968923`.

Deciding question: On current `main`, does the "reincarnates a guest-pinned Claude inbox responder after restart" test still read the mailbox once (not polled) right after the effect wait, with no newer PR or commit fixing that race?

Evidence:
- **Base is current:** `main`'s tip is still `91968923` (the merge of #234, 2026-11-03), which is exactly the PR's base. Nothing has landed on `main` since the PR was opened.
- **The bug is still there:** the last change to the test file on `main` was `05cc78fa` (#93, 2026-10-14). The test on `main` (line 323) still polls only the effect (`attempt < 100`). It then calls `listMessages()` once and expects `toBe(false)`, which is the race the PR fixes.
- **Not superseded:** a search for other responder or mailbox PRs found only #237 itself, plus #183 (Endo pin and credentials), which does not touch this test. #165 is already merged and is where the responder came from. No other PR fixes this flake.
- **The reason for the PR still holds:** the caplet still writes the effect before dismissing the message. The flake was seen on `main` at `9196892` (run 41729564029) and on PR #234, and a red run also skips the later guest-web daemon step in the same job.

No clean, panel, fix, CI-wait or un-draft budget was spent, and no repo or journal changes were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr237-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180468 cached reads)
- Output: 1633 tokens
- Cost: $0.43256960000000005
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
