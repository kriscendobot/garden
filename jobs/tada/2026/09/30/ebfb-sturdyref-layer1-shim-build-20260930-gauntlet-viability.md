**Gauntlet viability: endojs/endo-but-for-bots PR #774**

The gauntlet can proceed. PR #774 has not been superseded, and the maintainer's layering request that motivated it is only a few hours old. I finished the check last session, but the report was not recorded because the result marker came after the completion signal. This session only reissues the report with the signal last.

**Deciding question:** Is the maintainer's layer-1 SturdyRef shim request (endo-but-for-bots#695, comment 5903472512, 2026-09-30) still unmet on `llm` and still asking for this handler/enliven shim, with no newer implementation replacing #774?

Answer: yes.

**Evidence:**
- **PR state:** open, draft, `MERGEABLE`. Head is `95609a7c`, base is the frozen `llm-7ff30af`. It changes 19 files (+986), and was updated 2026-09-30T05:09Z.
- **Motivating directive:** kriskowal commented on #695 at 2026-09-30T03:28Z asking for a bottom-up stack. Its first layer is exactly this PR: a first-wins global `SturdyRef` shim modeled on HandledPromise, built from a handler, with `SturdyRef.enliven` calling the handler's `enliven` hook. The PR was reworked the same day to match that request and the layer-1 design contract, #1389, which is still an open draft.
- **Not on `llm`:** `packages/sturdyref` does not exist on `llm` (404, no commits under that path), and neither does `designs/sturdyref-shim-contract.md`. Nothing on the base has replaced it.
- **No competing PR:** among the related open PRs, #737 is stacked on this branch and #695/#871 are layer 9, waiting on this stack. The older bridge-cut PRs (#698–#704, #541) are the earlier `ocapn-sturdyref` line, which the stack plan says layer 5 will absorb. None of them is a newer layer-1 shim.
- **Discussion:** no review comments on #774 contradict the approach.

This stage spent no clean, panel, fix, CI-wait or un-draft budget. There were no commits, pushes or PRs.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228084 cached reads)
- Output: 2623 tokens
- Cost: $0.9098459999999999
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
