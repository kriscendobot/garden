PR #1394 can enter the gauntlet (`viability=proceed`). Nothing newer has replaced it, and the maintainer's request that motivated it still stands.

- **PR facts:** `feat(captp,ocapn): layer 5 — CapTP mints SturdyRefs and carries them over the wire`. It is open, unmerged and still a draft, with no reviews or comments yet. It was opened 2026-09-30T07:41Z.
- **Base:** it is stacked on layer 4 (#1393). The base is layer 4's head frozen as `build/sturdyref-marshal-representation-36c4f40` (base commit 36c4f40bcde).

Deciding question: Is PR #1394 still the current layer-5 slot in the SturdyRef layering stack kriskowal asked for, with no newer PR having replaced it?

Evidence:
- **Motivation still holds.** On 2026-09-30T03:28Z, kriskowal commented on #695 (issuecomment-5903472512). He paused that design until the SturdyRef layering underneath it makes progress, and spelled out the layers he wants: a SturdyRef shim, then pass-style, marshal and CapTP layers, and so on. This PR is layer 5 of the 9-layer stack built from that comment (garden tracker kriscendobot/garden#47).
- **Not superseded.** A search for every PR with "sturdyref" in the title turns up no other layer-5 or CapTP-wire PR. The older SturdyRef PRs (#698, #700–#704, #737, #871, #541) date from June and July and predate the maintainer's layering comment. The PR body says it drew on #698 and #700 as prior art rather than rebasing them, so this PR is the newer work that builds on them. The layers around it were all opened the same day and are all open: #774 (1), #1391 (2), #1392 (3), #1393 (4), #1396 (6), #1397 (7), #1398 (8) and design #1399 (9).
- **Premise intact.** Layer 4 (#1393) is open and still a draft, so this PR's base assumption still holds.

No garden files were changed and nothing was pushed; this stage only reads and reports.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (117410 cached reads)
- Output: 1348 tokens
- Cost: $0.41149
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
