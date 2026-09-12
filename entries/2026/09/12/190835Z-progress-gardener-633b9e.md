---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-12T19:08:36Z
---
[pr80-quota-validation] SUMMARY

Seven-day campaign summary for the manual quota-calibration system landed by
kriscendobot/garden#80 (merge SHA 33a84b7167d3f3d745bb0539f9ec0a2af93c9a66).
Compiled by the day-7 observer from the six prior daily entries plus today's.
All journal/GitHub prose was read as untrusted data. This remained a
MEASURE-only campaign throughout; nothing was ever actuated by these observers.

## Day coverage — COMPLETE, no gaps
Seven daily entries, one per UTC day, all present:
- day 20260906 — entries/2026/09/06/190719Z-progress-gardener-6c19ae.md
- day 20260907 — entries/2026/09/07/190728Z-progress-gardener-5b12e8.md
- day 20260908 — entries/2026/09/08/190829Z-progress-gardener-e8f63c.md
- day 20260909 — entries/2026/09/09/191029Z-progress-gardener-aeddb0.md
- day 20260910 — entries/2026/09/10/190758Z-progress-gardener-c41787.md
- day 20260911 — entries/2026/09/11/190802Z-progress-gardener-98d72f.md
- day 20260912 — this campaign's day-7 entry (above).
No missing days. The same three hosts were fit every day
(endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared); no
host appeared and then stopped being fit.

## Per-host trajectory over the week
- endolin-garden-ece02cb4: CONVERGED days 1–6, PROVISIONAL day 7. Grade held
  converged while the governing segment WAS the live weekly window; the fit
  tracked new checkpoints sensibly (governing segment grew n_points 5→8 as the
  human fed readings through 09-09, selected_cap settling DOWNWARD from ~154.8M
  low-band to ~147.7M low-band — converging from above toward the 143M setpoint).
  Day-7 downgrade to PROVISIONAL is the 2026-09-12T03:00Z weekly reset advancing
  the live window past the (now-stale) governing segment, with no post-reset
  checkpoint to anchor a fresh fit. Correct behaviour.
- endolin-garden2-5bcdff64: CONVERGED days 1–6, PROVISIONAL day 7. Same shape:
  segment grew n_points 3→5, selected_cap settling to ~68.3M low-band (above the
  64M setpoint); day-7 downgrade for the identical weekly-reset-crossing reason.
- openai-codex-shared: INSUFFICIENT all seven days. Never had usable paired
  checkpoints (null meter_spend / pairing_confidence "none"), plus an unresolved
  "85% remaining" discontinuity whose quota dimension (daily vs weekly) kriskowal
  was asked to clarify on day 1 and which remains open. Honest, stable grade.

## Effectiveness assessment (the campaign's question)
The PR-80 MECHANISM is EFFECTIVE and sound:
1. Deterministic: across 7 days and 3 hosts the fits were reproducible; changes
   in selected_cap tracked exactly the checkpoints that were added, never noise.
2. Boundary-respecting: the measure/actuate boundary HELD on every one of the
   seven days. fit-quota-calibration.sh --dry-run never crashed (exit 0 each
   day), never wrote budget/quota-fit/<host>.json, and never changed
   config/budget-pools. No other actor broke the boundary either.
3. Converged when it should, refused when it should: both anthropic hosts reached
   CONVERGED with a live, tolerance-passing segment (days 1–6), and correctly
   downgraded to PROVISIONAL the moment the weekly reset made the best segment
   stale (day 7). codex stayed INSUFFICIENT on thin/flagged data rather than
   inventing a cap. This is exactly the intended honesty.

Two GAPS, both OPERATIONAL/human — NOT code defects in PR-80:
A. Checkpoint feeding stopped after 2026-09-09T19:23Z. The newest checkpoint on
   every host has been frozen for days 5–7, and the new post-09-12-reset weekly
   window has ZERO checkpoints — which is precisely why day-7 fits can grade no
   better than PROVISIONAL. The machinery works only as well as the human feeds
   it dashboard readings; for the last ~3 days it was not fed.
B. No promotion ever happened. budget/quota-fit/ was never created and
   config/budget-pools was never changed across the whole week, so the
   measure→promote path (set-budget-pool.sh) has NEVER been exercised
   end-to-end. The converged fits sat above the conservative actuated caps the
   entire week, yet no deliberate promotion validated the second half of the
   workflow. This confirms the boundary holds, but leaves the promote leg untested.

## Follow-up
No fixer/design follow-up job is warranted: no real code defect was found — the
fit script is deterministic, exit-0, boundary-respecting, and honestly graded all
week. The two gaps are operational and belong to the maintainer, not to the
automation:
- Resume feeding dashboard checkpoints into the NEW post-2026-09-12T03:00Z weekly
  window so anthropic fits can re-reach CONVERGED (they are PROVISIONAL purely for
  lack of fresh-window data).
- Optionally exercise the promote path once (set-budget-pool.sh) to validate the
  measure→promote leg end-to-end, which the week never tested.
- Resolve the codex "85% remaining" dimension ambiguity (daily vs weekly) so the
  codex pool can become fittable instead of perpetually INSUFFICIENT.
These are recorded here and messaged to the maintainer; none requires a posted job.
