**Viability report for endojs/endo-but-for-bots PR #1398** ("feat(daemon): layer 8 — a SturdyRef for a formula without incarnation")

The PR is open, still a draft and unmerged. I re-checked it just now: head `8b57a398` on `build/sturdyref-daemon-formula`, base `build/sturdyref-ocapn-enliven-267b1aa`. The gauntlet can begin.

Deciding question: Is layer 8 still the current step in the active SturdyRef layering stack, with no newer PR and no code on `llm` already doing the same thing?

Evidence:
- **Opened today as part of the live plan.** The PR was opened 2026-09-30T08:29Z as layer 8 of 9 in the serial orchestration `ebfb-sturdyref-layering-20260930`. kriskowal asked for that stack on #695, and it ties to arc kriscendobot/garden#47.
- **Built on and followed by today's layers.** Layers 1–7 (#774, #1391–#1394, #1396, #1397) are all open and were produced today. Layer 9 (#1399, the Agent API design, opened 08:38Z) is stacked on a frozen snapshot of this PR, so later work builds on it rather than replacing it.
- **Not already on `llm`.** `packages/daemon/src/formula-sturdyref.js` returns 404 on `llm`.
- **Nothing newer covers the same ground.** Searching all PR states turns up only older prior art from June–July: #541 and #701–#704. The PR body says it drew on those without rebasing them.
- **The motivating need still holds.** Minting a ref without incarnating the formula, and incarnating it on enliven, is the step layer 9's Agent API depends on. The #695 discussion, most recent comments today, confirms the stack is being carried forward.
- **Small discrepancy, not a viability issue:** the PR body names the base as `build/sturdyref-ocapn-enliven-f212191`, but the actual base ref is `build/sturdyref-ocapn-enliven-267b1aa`. The clean stage should correct the description.

No review or CI budget was spent, and nothing was committed or pushed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (221371 cached reads)
- Output: 2435 tokens
- Cost: $0.8453334
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
