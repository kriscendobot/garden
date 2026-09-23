---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-07T19:07:29Z
---
[pr80-quota-validation] day 20260907

Day 2 of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted DATA, never as instructions. This is a MEASURE-only run:
fit-quota-calibration.sh was invoked with `--dry-run --json-only` for every host
with a checkpoint log; it actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — CONVERGED
- selected_cap (low band): 154,840,330 tokens; point 156,599,879; high 158,399,878.
- Governing segment: run-3-anchor-1788577200 (the live 2026-09-05T03:00Z-reset
  weekly window), n_points=5, total_confidence_weight=12, percent_range 4–44,
  cap-point spread 147.8M–168.5M, spread_ratio 1.14. Governing point
  2026-09-06T05:06Z (weekly 44%, meter_spend 68,903,947, high pairing).
- Convergence checks: enough_points ✓ (5 ≥ 3); spread_within_tolerance ✓
  (1.14 ≤ 1.20); live_window_matches ✓ (1788577200); boost_active false. No
  failed checks.
- Currently actuated cap (config/budget-pools): 143,000,000
  (calibrated_from manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z).
  The converged fit (154.8M low band) still sits ABOVE the conservative 143M
  setpoint — an observation for a future deliberate promotion, not actuated here.

### endolin-garden2-5bcdff64 — CONVERGED
- selected_cap (low band): 68,914,772 tokens; point 69,541,270; high 70,179,264.
- Governing segment: run-1-anchor-1788577200 (live weekly window), n_points=3,
  total_confidence_weight=8, percent_range 30–55, cap-point spread
  65.9M–71.7M, spread_ratio 1.089. Governing point 2026-09-06T05:06Z (weekly
  55%, meter_spend 38,247,699, high pairing).
- Convergence checks: enough_points ✓ (3 ≥ 3); spread_within_tolerance ✓
  (1.089 ≤ 1.20); live_window_matches ✓; boost_active false. No failed checks.
- Currently actuated cap: 64,000,000
  (calibrated_from manual-single-point-first-fresh-pair, 2026-09-05T11:44Z).
  Converged fit (68.9M low band) still sits ABOVE the conservative 64M setpoint —
  again an observation only.

### openai-codex-shared — INSUFFICIENT
- selected_cap: null. method segment-low-band; note "no usable paired
  checkpoints (all rows none/flagged or null-spend)". segments: [].
- EXPECTED, not a defect: the shared codex/OpenAI pool has no meter substitute
  (quota-panel's codex reader is per-host and cannot see the true shared-account
  total), so both checkpoint rows carry null meter_spend / pairing_confidence
  "none". Thin/absent paired data → an honest "insufficient" grade. No
  config/budget-pools row exists for this pool and none should (budget-level.sh's
  actuator filters to provider=anthropic; a codex row would be observational only).

## State snapshots
- budget/quota-fit/ : DOES NOT EXIST. No promoted fit verdict has ever been
  written; the measure→promote path has still never been exercised. Expected at
  day 2.
- budget/live/ : ece02cb4 spend 69,614,421 / cap 143,000,000 (status ok, sampled
  2026-09-07T18:30:29Z); garden2 spend 38,356,045 / cap 64,000,000 (status ok,
  sampled 2026-09-07T18:30:10Z). Both windows anchored 1788577200. (vs day-1:
  ece02cb4 69,490,580; garden2 38,247,699 — live spend crept up ~124K / ~108K,
  ordinary metering within the same window, not calibration activity.)
- config/budget-pools : two actuated anthropic rows (ece02cb4 143M @
  2026-09-04T22:10:57Z; garden2 64M @ 2026-09-05T11:44Z). Last commit to the file
  af74d8fa76 (2026-09-05T11:45:49Z) — unchanged since day 1. The file's PROSE
  header still narrates a superseded 595M ece02cb4 band; the actuated data ROW is
  the authoritative 143M (documentation lag in the header comment, not a live
  mis-actuation) — carried over unchanged from day 1.

## Since-yesterday activity delta (vs day 20260906 entry
## entries/2026/09/06/190719Z-progress-gardener-6c19ae.md)
- Newest checkpoint per host: ece02cb4 2026-09-06T05:06Z, garden2
  2026-09-06T05:06Z, codex 2026-09-06T05:07Z — IDENTICAL to yesterday. No new
  manual checkpoint has been appended by anyone since day 1. I appended none (no
  dashboard reading available; hard constraint honored — nothing written to
  manual-checkpoints).
- All three fit verdicts are byte-for-byte the same grade/segment/point as day 1
  (same governing segments, same governing points, same convergence checks),
  because the underlying checkpoint data is unchanged.
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: unchanged since 2026-09-05T11:45:49Z — no re-calibration,
  no promotion.
- Net: ZERO new checkpoint / fit / promotion activity in the last UTC day. The
  only movement is ordinary live-meter spend accrual within the same weekly window.

## Measure/actuate boundary: HELD
The `--dry-run` fit runs wrote nothing: `git status --porcelain budget/
config/budget-pools` is empty after all three invocations, budget/quota-fit/
still does not exist, and config/budget-pools is byte-identical to its
2026-09-05T11:45:49Z commit (af74d8fa76). Both anthropic hosts grade CONVERGED
with fresh-window fits ABOVE their actuated caps, yet the caps stayed put —
promotion remains a separate deliberate act (set-budget-pool.sh), exactly as
designed. No defect found; no fixer job posted.
