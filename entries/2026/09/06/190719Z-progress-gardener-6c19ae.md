---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-06T19:07:20Z
---
[pr80-quota-validation] day 20260906

Day 1 of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted data. This is a MEASURE-only run: fit-quota-calibration.sh was
invoked with `--dry-run --json-only` for every host with a checkpoint log; it
actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — CONVERGED
- selected_cap (low band): 154,840,330 tokens; point 156,599,879; high 158,399,878.
- Governing segment: run-3-anchor-1788577200 (the live 2026-09-05T03:00Z-reset
  weekly window), n_points=5, total_confidence_weight=12,
  percent_range 4–44, cap-point spread 147.8M–168.5M, spread_ratio 1.14.
  Governing point 2026-09-06T05:06Z (weekly 44%, meter_spend 68,903,947, high
  pairing).
- Convergence checks: enough_points ✓ (5 ≥ 3); spread_within_tolerance ✓
  (1.14 ≤ 1.20); live_window_matches ✓ (1788577200); boost_active false. No
  failed checks.
- Currently actuated cap (config/budget-pools): 143,000,000
  (calibrated_from manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z).
  The fresh converged fit (154.8M low band) now sits ABOVE the conservative
  143M setpoint — an observation for a future deliberate promotion, not actuated
  by this job.

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
  Converged fit (68.9M low band) sits ABOVE the conservative 64M setpoint —
  again an observation only.

### openai-codex-shared — INSUFFICIENT
- selected_cap: null. method segment-low-band; note "no usable paired
  checkpoints (all rows none/flagged or null-spend)". No segments.
- This is EXPECTED, not a defect: the shared codex/OpenAI pool has no meter
  substitute (per its checkpoint notes, quota-panel's codex reader is per-host
  and cannot see the true shared-account total), so both checkpoint rows carry
  null meter_spend / pairing_confidence "none". Thin/absent paired data → an
  honest "insufficient" grade. No config/budget-pools row exists for this pool
  and none should — budget-level.sh's actuator filters to provider=anthropic, so
  a codex row would be observational only.

## State snapshots
- budget/quota-fit/ : DOES NOT EXIST. No promoted fit verdict has ever been
  written; the measure→promote path has never been exercised. Itself an
  observation (absence is expected at day 1).
- budget/live/ : ece02cb4 spend 69,490,580 / cap 143,000,000 (status ok,
  sampled 2026-09-06T19:00:08Z); garden2 spend 38,247,699 / cap 64,000,000
  (status ok, sampled 2026-09-06T19:00:29Z). Both windows anchored 1788577200.
- config/budget-pools : two actuated anthropic rows (ece02cb4 143M @
  2026-09-04T22:10:57Z; garden2 64M @ 2026-09-05T11:44Z). Last commit to the
  file af74d8fa76 (2026-09-05T11:45:49Z). Note: the file's PROSE header still
  narrates a 595M ece02cb4 band from a superseded 2026-09-03 calibration; the
  actuated data ROW is the authoritative 143M — a documentation/data lag in the
  header comment, not a live mis-actuation.

## Since-yesterday activity delta
This is the FIRST `[pr80-quota-validation] day` entry (no prior day exists;
baseline is the setup tada kriscendobot-garden-pr80-validation-setup-20260905).
- Newest checkpoint per host: ece02cb4 2026-09-06T05:06Z, garden2
  2026-09-06T05:06Z, codex 2026-09-06T05:07Z (all kriskowal-reported, human
  dashboard readings). No new checkpoints appended by me (I have no dashboard
  reading; hard constraint honored — nothing written to manual-checkpoints).
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: unchanged since 2026-09-05T11:45:49Z — no re-calibration.

## Measure/actuate boundary: HELD
The `--dry-run` fit runs wrote nothing: budget/quota-fit/ still does not exist
after all three invocations, `git status --porcelain` shows no change under
budget/, and config/budget-pools is byte-identical to its 2026-09-05 commit. Both
anthropic hosts now grade CONVERGED with fresh-window fits ABOVE their actuated
caps, yet the caps stayed put — promotion remains a separate deliberate act
(set-budget-pool.sh), exactly as designed. No defect found; no fixer job posted.
