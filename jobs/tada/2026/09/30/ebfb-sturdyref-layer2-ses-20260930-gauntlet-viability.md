The viability check for PR #1391 (`feat(ses): layer 2 — permit and propagate a pre-lockdown SturdyRef`) is finished, and the gauntlet can go ahead. This is the same report as before. The last session put the stage marker after the completion signal, so the signal was never read; this time the signal is the last line.

Deciding question: Is the SES accommodation for `SturdyRef` still wanted by the maintainer and still missing from both the `llm` branch and every other open PR?

Evidence:
- **PR state:** open, draft and not merged. It was opened 2026-09-30T06:18Z with head `caa792be` and has no reviews or comments yet. It sits on the frozen layer-1 base `build/sturdyref-shim-first-wins-95609a7`, which is stacked on #774.
- **Why it exists:** kriskowal's comment on #695 (issuecomment-5903472512) sets out a 9-layer SturdyRef plan. Item 2 is exactly this PR: SES permits `SturdyRef` and passes it to child compartments when it is present at `repairIntrinsics` time. The work is tracked in kriscendobot/garden#47.
- **Not already landed:** `packages/ses/src/permits.js` on `llm` does not mention `SturdyRef`.
- **Not superseded:** no open or closed PR does the SES side instead. #737 changes pass-style (layer 3), and #697–#704 and #539/#541 are older daemon and OCapN bridge work. Layer 1 (#774) and its design (#1389) are still open drafts, so this PR's base still stands.
- **Caveat for the panel:** the real layer-1 shim can't yet be installed before `lockdown()`, so this PR's tests use a stand-in. That depends on #774 adding a pre-lockdown path; it doesn't undercut the need for this layer.

Nothing was changed, and none of the gauntlet's own budget (clean, panel, fix, CI wait, un-draft) was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172820 cached reads)
- Output: 2090 tokens
- Cost: $0.8722342000000001
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
