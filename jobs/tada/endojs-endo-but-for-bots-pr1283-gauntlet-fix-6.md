The fix-6 stage is complete. Re-derived state:

## Summary

**Job:** Gauntlet FIX round 6 for endojs/endo-but-for-bots PR #1283 (`design(ironhorse): benchmark-established computron baseline regime`).

**What I found on requeue:** A prior fix-6 attempt (reaped during CI wait) had already committed and pushed the panel-6 fixes to the PR head branch `design/ironhorse-computron-benchmark-baseline`:
- `65fb7a9d69` — "address panel-6 review items" (comprehensive, +123 net lines across the design + README)
- `bb36a0b6c9` — "fix README em-dash-to-comma false series (panel-6 pedant)"

**Verification (I did not redo the work — I confirmed it):** Spot-checked the panel-6 (round 6, 09:23:43Z) must-fix items against the current file at HEAD `bb36a0b6c9`:
- critic (constant basis rank-deficient) → now handled explicitly, `coefficient: "0"` / rank-deficient note present.
- ergonomist (inconsistent provenance unit keys) → unified to `time_medians_ns` (no stray `_ms`).
- pedant (triple space; `§` as syntactic constituent) → prose triple-spaces gone (only mermaid `<br/>` indents remain); noun-form `§ F4` recasts applied.
- novice (worked example fewer than four ladder sizes) → JSON examples now carry the ≥4-size ladder.

The remaining must-fix items (PR-lane cap/gate-1 escape, number-encoding rule, dangling modifier, illustrative-band contradiction, gate-input/provenance boundary) were part of the same comprehensive commit.

**CI:** Green — `ci-wait-merge.sh --no-merge` returned rc 0 (29 checks, 0 failed; design-only diff so most CI lanes correctly SKIP).

**Stopping here** per the fix-stage contract — no panel re-run; the driver re-posts panel-7.

**Follow-ups:** none from this stage; panel-7 will re-adjudicate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1283-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 114 tokens (5367772 cached reads)
- Output: 47662 tokens
- Cost: $5.704235000000001
- Wall-clock: 1396s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
