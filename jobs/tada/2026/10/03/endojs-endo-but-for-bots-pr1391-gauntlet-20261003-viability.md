**Viability verdict for endojs/endo-but-for-bots#1391: proceed.**

The PR is still worth running the gauntlet on. It is open, unmerged and in draft, at head `008820366e`. Its base is the frozen `build/sturdyref-shim-first-wins-ef4662f`, which is layer 1 of the stack (#774, also open and draft). No clean, panel, fix or CI budget was spent, and I made no changes to the repo or the garden.

Deciding question: Is "SES permits a pre-lockdown `SturdyRef` shim and shares it with child compartments" still unimplemented on `llm`, and is it still something the maintainer wants?

Evidence:
- **Still wanted.** On 2026-09-30, three days ago, kriskowal laid out the nine-layer SturdyRef plan on #695 (comment 5903472512). Item 2 is exactly this PR's content: "An accommodation for SturdyRef in SES, such that it is permitted and propagated to child compartments if present in the realm at the time of repairIntrinsics." The garden turned that plan into a serial orchestration, `ebfb-sturdyref-layering-20260930`, tied to kriscendobot/garden#47. This PR is layer 2 of it, and layers 3–9 (#1392, #1393, #1394, #1396, #1398, #1399) are stacked above it. Nothing later from the maintainer reverses that plan.
- **Not superseded.** `packages/ses/src/permits.js` on `llm` has no mention of `SturdyRef`. The last change to `packages/ses/src` on `llm` is `0b97b938a4` (an upstream merge on 2026-09-29), and none of the recent ses commits touch SturdyRef. No other open or closed PR with "SturdyRef" in the title implements the SES layer; this is the only one.
- **Not a viability problem, but worth knowing:**
  - The previous gauntlet run (`ebfb-sturdyref-layer2-ses-20260930-gauntlet`) halted after round 4 with CI red, because its fix stage declared its outcome failed.
  - Since then, round 5 of the review panel and a fifth fix round have landed. The fix round folded the 14 commits from earlier review rounds into 4 logical commits.
  - The new gauntlet's clean and fix stages should start from head `008820366e` and from what the round-5 panel found (coverage-auditor and integrator requested changes).

Follow-ups: none.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (234183 cached reads)
- Output: 2364 tokens
- Cost: $0.5059326
- Wall-clock: 68s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
