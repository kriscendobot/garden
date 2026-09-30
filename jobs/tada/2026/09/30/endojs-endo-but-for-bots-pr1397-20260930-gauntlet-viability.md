PR #1397 is still viable, so the gauntlet may begin. I spent no clean, panel, fix or CI budget on this check.

**Deciding question:** Is the current base (layer 6's head) and newer `llm` history still missing the fix #1397 makes: sharing the bootstrap `fetch`'s swiss-number lookup with the home enliven path, so a SturdyRef that comes back home with byte secrets reaches a string-keyed locator? Is layer 7 still a live slot in the stack the maintainer asked for? **Answer: yes to both.**

**Evidence:**
- **PR state:** open and draft, opened 2026-09-30T07:59Z. Head is `267b1aa05` on `build/sturdyref-ocapn-enliven`, and the base is `build/sturdyref-captp-construct-7a34114`. The PR has no comments or reviews yet.
- **Base is current:** the base `7a341141` is exactly the current head of layer 6 (#1396), and the head is 1 commit ahead and 0 behind it. The PR body says the base was frozen at `ef45f1d`, but the actual base ref matches layer 6's current head, so that line is just stale.
- **The defect is still on the base:** in `packages/ocapn/src/client/sturdyrefs.js` at the base, the home path calls `locator.get(secret)` (line 181) with raw bytes. The ASCII-decode-then-fallback lookup exists only in the tracker's `lookup` (lines 249–262). That split is exactly what the PR fixes.
- **Newer `llm` history hasn't overtaken it:** the last change to `sturdyrefs.js` on `llm` is `3acee4a56` from 2026-08-30 (#475, narrowing byte handling to `Uint8Array`). Nothing has landed a shared home and remote lookup there.
- **The premise still holds:** this is layer 7 of the 9-layer SturdyRef stack requested in https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512 (arc kriscendobot/garden#47). Every other layer is open, from #774 and #1391–#1396 below it to #1398 and #1399 above it, and all were opened today. No merged or newer PR takes its place.
- **Stacking caveat, not a blocker:** #1397 sits on the unmerged layers 1–6, so un-drafting and merging have to follow the stack order.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162265 cached reads)
- Output: 2015 tokens
- Cost: $0.40400099999999994
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
