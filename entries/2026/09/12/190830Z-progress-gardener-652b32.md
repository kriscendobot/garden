---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-12T19:08:31Z
---
[pr80-quota-validation] day 20260912

Day 7 (final) of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted data. This is a MEASURE-only run: fit-quota-calibration.sh was
invoked with `--dry-run --json-only` for every host with a checkpoint log; it
actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — PROVISIONAL (downgraded from CONVERGED)
- selected_cap (low band): 147,687,576 tokens; point 148,773,514; high 149,875,540.
- Governing segment: run-3-anchor-1788577200, n_points=8, total_confidence_weight=21,
  percent_range 4–68, cap-point spread 147.80M–168.52M, spread_ratio 1.14.
  Governing point 2026-09-09T19:23Z (weekly 68%, meter_spend 101,165,990, high pairing).
- Checks: enough_points ✓ (8 ≥ 3); spread_within_tolerance ✓ (1.14 ≤ 1.20);
  boost_active false. FAILED CHECK: live_window_matches = FALSE — the governing
  segment is anchored at window 1788577200, but the live window is now
  1789182000. The weekly quota RESET at 2026-09-12T03:00Z advanced the live
  window, and no checkpoint has been fed into the new window, so the freshest
  usable segment is the prior (now-closed) window → grade drops CONVERGED→PROVISIONAL.
  This is correct deterministic behaviour, not a fault.
- Actuated cap (config/budget-pools): 143,000,000 (calibrated_from
  manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z). Fresh fit
  (147.7M low band) still sits ABOVE the 143M setpoint — an observation for a
  future deliberate promotion, not actuated here.

### endolin-garden2-5bcdff64 — PROVISIONAL (downgraded from CONVERGED)
- selected_cap (low band): 68,328,025 tokens; point 68,796,026; high 69,270,481.
- Governing segment: run-1-anchor-1788577200, n_points=5, total_confidence_weight=14,
  percent_range 30–73, cap-point spread 65.87M–71.75M, spread_ratio 1.089.
  Governing point 2026-09-09T19:23Z (weekly 73%, meter_spend 50,221,099, high pairing).
- Checks: enough_points ✓; spread_within_tolerance ✓ (1.089 ≤ 1.20);
  boost_active false. FAILED CHECK: live_window_matches = FALSE (governing
  1788577200 vs live 1789182000) — same weekly-reset crossing as ece02cb4.
- Actuated cap: 64,000,000 (calibrated_from manual-single-point-first-fresh-pair,
  2026-09-05T11:44:00Z). Fresh fit (68.3M low band) still above the 64M setpoint.

### openai-codex-shared — INSUFFICIENT
- selected_cap: null. method segment-low-band; note "no usable paired checkpoints
  (all rows none/flagged or null-spend)". segments=[]. boost_active false.
- The newest codex checkpoint (2026-09-09T19:23Z) carries pairing_confidence
  "none", null meter_spend, and a flagged "85% remaining" discontinuity whose
  quota dimension is still unresolved (daily vs weekly). Thin/flagged data → an
  honest INSUFFICIENT grade, unchanged all seven days. No config/budget-pools row
  exists for this pool; nothing to actuate.

## Promotion path
- budget/quota-fit/ : DOES NOT EXIST. No promoted fit verdict has ever been
  written across the whole campaign; the measure→promote path remains unexercised
  end-to-end. Itself an observation, not a defect.

## Since-yesterday activity delta (vs day 20260911 entry 190802Z-progress-gardener-98d72f)
- Newest checkpoint per host is FROZEN at 2026-09-09T19:23:00Z for all three —
  byte-identical to days 5/6/7. No human has appended a checkpoint since 09-09;
  I appended none (I have no dashboard reading, per the hard constraint).
- The one real change vs yesterday: both anthropic hosts dropped CONVERGED→PROVISIONAL.
  The cause is NOT new data and NOT a code change — it is the 2026-09-12T03:00Z
  weekly reset advancing the live window (1788577200 → 1789182000) past the
  governing segment, flipping live_window_matches to false. The fit responded
  correctly by refusing to call a stale-window segment "converged".
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: content unchanged (still the 2026-09-04/09-05 rows; the
  file mtime of 2026-09-10 is a journal-sync artifact, not a content edit). No
  re-calibration, no promotion, nothing attributable to my run.

## Measure/actuate boundary: HELD
fit-quota-calibration.sh ran with `--dry-run --json-only` for all three hosts,
exited 0 (no crash), wrote NO budget/quota-fit/<host>.json (the dir is still
absent), and changed config/budget-pools not at all. The grade downgrade was a
read-only verdict, exactly as designed. Promotion remains a separate deliberate
act (set-budget-pool.sh) that no one has taken.
