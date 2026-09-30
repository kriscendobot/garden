**Viability report: endojs/endo-but-for-bots PR #1396** (layer 6: construct a SturdyRef from its data)

PR facts, as read last session: the PR is OPEN, a draft and not merged. Head is `build/sturdyref-captp-construct` @ `ef45f1dc`, and base is `build/sturdyref-captp-wire-dc0027b`, the frozen head of layer 5 (#1394). It had no comments or reviews. It was opened 2026-09-30T07:49Z, minutes before this gate ran, so I did not query it again.

Deciding question: Is layer 6 of the maintainer's 9-layer SturdyRef stack, "each CapTP can construct a SturdyRef from its data", still an open need that nothing newer has delivered?

Evidence:
- The maintainer asked for this layer explicitly. In https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5903472512, kriskowal listed it as item 6 of the layering they want, and asked for the work as a stack of changes to review one by one and as a whole. The arc, kriscendobot/garden#47, is still active.
- The stack below it is current. Layers 1–5 (#774/#1389, #1391, #1392, #1393, #1394) are all open, and #1396 is stacked on #1394's frozen head as intended. Layers 7–9 are still unopened.
- Nothing newer has replaced it:
  - `llm`'s `packages/captp/src/captp.js` has no SturdyRef code (a case-insensitive grep for "sturdy" finds 0 matches).
  - A GitHub code search for `makeSturdyRefFromData` returns 0 results.
  - The older SturdyRef PRs (#737, #700, #701, #541, #703, #704, #698) are earlier designs and bridge work that this stack reorganizes, not newer implementations of this capability.
- The premise still holds: the daemon work in layer 8, still pending, depends on this layer.

The PR has not been superseded, and the need behind it still holds. I spent no clean, panel, fix or CI budget, and made no commits or pushes, since this stage needs none. The only change from last session's report is the order of the last two lines, which I swapped so the completion signal comes last.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228722 cached reads)
- Output: 2305 tokens
- Cost: $0.9031237999999999
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
