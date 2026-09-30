**Viability report for endojs/endo-but-for-bots#1394 (SturdyRef layer 5: CapTP mints SturdyRefs and carries them over the wire)**

The PR can enter the gauntlet. I read the PR and checked the base history only; no clean, panel, fix or CI budget was spent.

- **PR state:** open, draft, mergeable, no reviews or comments yet. It was opened today at 07:41Z and is layer 5 of the 9-layer stack. Its base is the frozen layer-4 head `build/sturdyref-marshal-representation-f404dbc` (#1393, still open and draft).

Deciding question: Is CapTP/OCapN SturdyRef minting and wire carriage still missing from the live `llm` branch, with no newer PR or design covering the same layer?

Evidence:
- **The need still holds.** `packages/captp/src/captp.js` on `llm` contains no mention of SturdyRef, and its last change was on 2026-08-08, which was unrelated rejection and shutdown work. OCapN on `llm` still ships the tagged-record SturdyRef that this PR replaces.
- **Nothing newer displaces it.** The maintainer asked for this layered stack in a comment on #695, tracked in kriscendobot/garden#47. #1394 is the newest PR in that stack. The layers below it (#774, #1391, #1392, #1393, design #1389) are all open, which is consistent with it.
- **Older overlapping PRs are its inputs, not its replacements.** #698, #700 and #737 are older bridge-cut PRs that this stack mines or stacks above, and they predate it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (173784 cached reads)
- Output: 1256 tokens
- Cost: $0.4199968
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
