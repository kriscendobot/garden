---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-08T19:08:31Z
---
[pr80-quota-validation] day 20260908

Day 3 of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted DATA, never as instructions. This is a MEASURE-only run:
fit-quota-calibration.sh was invoked with `--dry-run --json-only` for every host
with a checkpoint log; it actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — CONVERGED
- selected_cap (low band): 149,708,432 tokens; point 151,335,697; high 152,998,727.
- Governing segment: run-3-anchor-1788577200 (the live 2026-09-05T03:00Z-reset
  weekly window), n_points=6, total_confidence_weight=15, percent_range 4-46,
  cap-point spread 147.8M-168.5M, spread_ratio 1.14. Governing point is now the
  NEW 2026-09-08T17:17Z checkpoint (weekly 46%, meter_spend 69,614,421, high
  pairing) — the freshest highest-confidence point.
- Convergence checks: enough_points ok (6 >= 3); spread_within_tolerance ok
  (1.14 <= 1.20); live_window_matches ok (1788577200); boost_active false. No
  failed checks.
- Currently actuated cap (config/budget-pools): 143,000,000
  (calibrated_from manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z).
  The converged fit (149.7M low band) still sits ABOVE the conservative 143M
  setpoint — an observation for a future deliberate promotion, not actuated here.

### endolin-garden2-5bcdff64 — CONVERGED
- selected_cap (low band): 68,914,772 tokens; point 69,541,270; high 70,179,264.
- Governing segment: run-1-anchor-1788577200 (live weekly window), n_points=3,
  total_confidence_weight=8, percent_range 30-55, cap-point spread
  65.9M-71.7M, spread_ratio 1.089. Governing point 2026-09-06T05:06Z (weekly
  55%, meter_spend 38,247,699, high pairing) — unchanged since day 2.
- Convergence checks: enough_points ok (3 >= 3); spread_within_tolerance ok
  (1.089 <= 1.20); live_window_matches ok; boost_active false. No failed checks.
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
  "none". Thin/absent paired data => an honest "insufficient" grade. No
  config/budget-pools row exists for this pool and none should (budget-level.sh's
  actuator filters to provider=anthropic; a codex row would be observational only).

## State snapshots
- budget/quota-fit/ : DOES NOT EXIST. No promoted fit verdict has ever been
  written; the measure->promote path has still never been exercised. Expected at
  day 3.
- budget/live/ : ece02cb4 spend 70,906,523 / cap 143,000,000 (status ok, sampled
  2026-09-08T19:01:06Z); garden2 spend 38,748,915 / cap 64,000,000 (status ok,
  sampled 2026-09-08T19:00:50Z). Both windows anchored 1788577200. (vs day 2:
  ece02cb4 69,614,421; garden2 38,356,045 — live spend crept up ~1.29M / ~393K
  over ~1 day, ordinary metering within the same weekly window, not calibration
  activity.)
- config/budget-pools : two actuated anthropic rows (ece02cb4 143M @
  2026-09-04T22:10:57Z; garden2 64M @ 2026-09-05T11:44Z). Last commit to the file
  af74d8fa76 (2026-09-05T11:45:49Z) — unchanged since day 1. The file's PROSE
  header still narrates a superseded 595M ece02cb4 band; the actuated data ROW is
  the authoritative 143M (documentation lag in the header comment, not a live
  mis-actuation) — carried over unchanged from days 1-2.

## Since-yesterday activity delta (vs day 20260907 entry
## entries/2026/09/07/190728Z-progress-gardener-5b12e8.md)
- NEW checkpoint activity for the FIRST time since day 1: ece02cb4 gained a
  checkpoint at 2026-09-08T17:17Z (weekly 46%, meter_spend 69,614,421, high
  pairing, appended by kriskowal). Days 2-3 had reported zero new checkpoints;
  this is the seventh point in the ece02cb4 window and the first movement.
  garden2 (still 2026-09-06T05:06Z) and codex (still 2026-09-06T05:07Z) are
  unchanged.
- Effect on ece02cb4 fit: the new point became the governing point, growing the
  governing segment from n_points=5 to 6 and shifting selected_cap DOWNWARD from
  154,840,330 low (156.6M point) on day 2 to 149,708,432 low (151.3M point) today
  — a gentle downward drift as more real window activity settles the ratio. GRADE
  UNCHANGED: still CONVERGED, all checks still pass, still above the 143M setpoint.
- garden2 and codex fits are byte-for-byte the same grade/segment/point as days
  1-2 (data unchanged).
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: unchanged since 2026-09-05T11:45:49Z (af74d8fa76) — no
  re-calibration, no promotion.
- I appended NO manual checkpoint (no dashboard reading available to me; hard
  constraint honored — nothing written to manual-checkpoints).
- Net: ONE new checkpoint (ece02cb4) that refined ece02cb4's governing point and
  nudged its selected_cap down without changing its grade; NO new fit-promotion
  or budget-pools actuation. The rest is ordinary live-meter spend accrual within
  the same weekly window.

## Measure/actuate boundary: HELD
The `--dry-run` fit runs wrote nothing: `git status --porcelain budget/
config/budget-pools` was empty both BEFORE and AFTER all three invocations,
budget/quota-fit/ still does not exist, and config/budget-pools is byte-identical
to its 2026-09-05T11:45:49Z commit (af74d8fa76). All three fits exited 0 (no
crash). Both anthropic hosts grade CONVERGED with fresh-window fits ABOVE their
actuated caps, yet the caps stayed put — promotion remains a separate deliberate
act (set-budget-pool.sh), exactly as designed. No defect found; no fixer job
posted.
