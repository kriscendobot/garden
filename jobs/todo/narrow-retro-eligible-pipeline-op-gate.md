---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Narrow `retro_eligible` in `scripts/jobs/comment-watcher.sh` so a comment with no work-product to indict mints no review retrospective.

Maintainer decision (2026-08-15): this deliberately reverses the earlier err-toward-minting choice for two specific, deterministically-detectable shapes, and only those.

Gate OUT (mint no retro):
1. A `review`-classed comment whose only actionable content is a pipeline-op verb: conduct, rebase, shepherd, retcon, weave, merge, close.
2. An approval with an empty or whitespace-only body AND zero inline review comments.

Everything else keeps minting exactly as today. Do NOT widen this to any judgment-based filter: the 2026-07-01 directive keeps the LLM out of the watcher, so the gate must stay deterministic, in plain code, in the same verb-class `case` that already computes `retro_eligible` (around line 1708).

Grounding (measured against journal/review-misses/, 2026-08-15): 195 dismissed vs 50 real misses. All 195 dismissals are category `new-direction`. Of those, ~19 cite an empty-body approval with zero inline comments and ~16 cite a pipeline-op-only directive. So the honest expected yield is roughly 10-15% of retrospective spend, NOT the ~85% the source retrospective implied — 85% is the dismissal rate, whose dominant cause is genuinely new direction that no review surface could anticipate. Do not oversell the change in the commit message or the report.

This edits a tested hot path. Cover the new gate with tests alongside the existing comment-watcher tests, including the canonical case: an APPROVED review with a 35-character body "Please rebase, retcon, and conduct" and zero inline comments must mint the attention/finalization work as before but no retro.
