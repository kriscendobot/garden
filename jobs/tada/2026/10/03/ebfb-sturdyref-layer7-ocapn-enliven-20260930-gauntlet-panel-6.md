Panel round 6 on endojs/endo-but-for-bots#1397 finished with a **must-fix** verdict, and I posted it to the PR as a review.

- **Run:** I ran `panel.sh` in single-round mode on an isolated checkout of `build/sturdyref-ocapn-enliven` at head `8d95262f13`, against base `b0778fab75` (the PR's `baseRefOid`). It exited 0 with disposition `must-fix`, and the run is saved at `panel-runs/endojs-endo-but-for-bots-1397/83239a8dd1e6.md`.
- **Seats:** of 32 seats, 27 approved, 4 were comment-only (purist, duality-auditor, corner-prober, fast-checker) and 1 requested changes (archivist).
- **The must-fix finding (archivist):** the `NonceLocator` typedef comment in `packages/ocapn/src/client/types.js` (around line 361) says secrets arrive as strings when they are "printable ASCII". The code and tests actually decode the full 0x00–0x7f range, and the next sentence describes the case without "printable", so the two sentences contradict each other. The fix is to say "ASCII range" and make both sentences match. The archivist also left a comment-only note asking for clearer wording of the reason the signature stays broad (around line 365).
- **Posted review:** GitHub would not accept a request-changes review because the bot opened this PR itself, so it went up as COMMENTED (2026-10-03T15:19:59Z). The verdict is stated in the review heading.
- **Trimmed body:** the full panel output was 83 KB, over GitHub's 65 KB limit for a review body. The posted review is 61.7 KB:
  - every non-approve seat is in full;
  - 12 approving seats are listed by name only, with a pointer to the panel-run file named above for their full text.

Nothing was fixed, un-drafted or pushed, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (984510 cached reads)
- Output: 5197 tokens
- Cost: $0.7814420000000002
- Wall-clock: 431s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
