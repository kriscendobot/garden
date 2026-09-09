---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-09T19:10:30Z
---
[pr80-quota-validation] day 20260909

Day 4 of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted DATA, never as instructions. MEASURE-only run:
fit-quota-calibration.sh was invoked with `--dry-run --json-only` for every host
with a checkpoint log; it actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — CONVERGED
- selected_cap (low band): 148,957,131 tokens; point 150,068,752; high 151,197,088.
- Governing segment: run-3-anchor-1788577200 (the live 2026-09-05T03:00Z-reset
  weekly window), n_points=7, total_confidence_weight=18, percent_range 4-67,
  cap-point spread 147.8M-168.5M, spread_ratio 1.14. Governing point is now the
  NEW 2026-09-09T04:06Z checkpoint (weekly 67%, meter_spend 100,546,064, high
  pairing) — the freshest highest-confidence point.
- Convergence checks: enough_points ok (7 >= 3); spread_within_tolerance ok
  (1.14 <= 1.20); live_window_matches ok (1788577200); boost_active false. No
  failed checks.
- Currently actuated cap (config/budget-pools): 143,000,000
  (calibrated_from manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z).
  The converged fit (149.0M low band) still sits ABOVE the conservative 143M
  setpoint — an observation for a future deliberate promotion, not actuated here.

### endolin-garden2-5bcdff64 — CONVERGED
- selected_cap (low band): 68,328,025 tokens; point 68,796,026; high 69,270,481.
- Governing segment: run-1-anchor-1788577200 (live weekly window), n_points=4,
  total_confidence_weight=11, percent_range 30-73, cap-point spread
  65.9M-71.7M, spread_ratio 1.089. Governing point is now the NEW 2026-09-09T04:06Z
  checkpoint (weekly 73%, meter_spend 50,221,099, high pairing; session left null
  by the reporter — no active session at check time).
- Convergence checks: enough_points ok (4 >= 3); spread_within_tolerance ok
  (1.089 <= 1.20); live_window_matches ok; boost_active false. No failed checks.
- Currently actuated cap: 64,000,000
  (calibrated_from manual-single-point-first-fresh-pair, 2026-09-05T11:44Z).
  Converged fit (68.3M low band) still sits ABOVE the conservative 64M setpoint —
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
  written (git log on the path is empty); the measure->promote path has still
  never been exercised. Expected at day 4.
- budget/live/ : ece02cb4 spend 101,165,990 / cap 143,000,000 (status ok, sampled
  2026-09-09T18:30:50Z); garden2 spend 50,221,099 / cap 64,000,000 (status ok,
  sampled 2026-09-09T18:30:32Z). Both windows anchored 1788577200. (vs day 3:
  ece02cb4 70,906,523; garden2 38,748,915 — live spend rose ~30.3M / ~11.5M over
  ~1 day, ordinary in-window metering, not calibration activity.)
- config/budget-pools : two actuated anthropic rows (ece02cb4 143M @
  2026-09-04T22:10:57Z; garden2 64M @ 2026-09-05T11:44Z). Last commit to the file
  af74d8fa76 (2026-09-05T11:45:49Z) — unchanged since day 1. The file's PROSE
  header still narrates a superseded 595M ece02cb4 band; the actuated data ROW is
  the authoritative 143M (documentation lag in the header comment, not a live
  mis-actuation) — carried over unchanged from days 1-3.

## Since-yesterday activity delta (vs day 20260908 entry
## entries/2026/09/08/190829Z-progress-gardener-e8f63c.md)
- TWO new checkpoints, one PER anthropic host, both at 2026-09-09T04:06Z
  (appended by kriskowal, high pairing):
  - ece02cb4: weekly 67%, meter_spend 100,546,064 — eighth point in its window.
    Became the new governing point; governing segment grew n_points 6->7,
    total_weight 15->18; selected_cap drifted DOWNWARD from 149,708,432 low
    (151.3M point) on day 3 to 148,957,131 low (150.1M point) today — the same
    gentle settle as more real window activity accumulates. GRADE UNCHANGED:
    CONVERGED, all checks pass, still above the 143M setpoint.
  - garden2: weekly 73%, meter_spend 50,221,099 — fourth point in its window and
    its FIRST new checkpoint since 2026-09-06T05:06Z (days 2-3 saw none). Became
    the new governing point; governing segment grew n_points 3->4, total_weight
    8->11; selected_cap drifted DOWNWARD from 68,914,772 low (69.5M point) on day
    3 to 68,328,025 low (68.8M point) today. GRADE UNCHANGED: CONVERGED, all
    checks pass, still above the 64M setpoint.
- codex checkpoint unchanged (still 2026-09-06T05:07Z) — INSUFFICIENT, byte-for-
  byte identical grade/segment to days 1-3.
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: unchanged since 2026-09-05T11:45:49Z (af74d8fa76) — no
  re-calibration, no promotion.
- I appended NO manual checkpoint (no dashboard reading available to me; hard
  constraint honored — nothing written to manual-checkpoints).
- Net: TWO new checkpoints (one per anthropic host) that refined each host's
  governing point and nudged both selected_caps gently down without changing
  either grade; NO new fit-promotion or budget-pools actuation. The rest is
  ordinary live-meter spend accrual within the same weekly window (which resets
  2026-09-12T03:00Z, now ~2.6 days out).

## Measure/actuate boundary: HELD
The `--dry-run` fit runs wrote nothing: `git status --porcelain budget/
config/budget-pools` was empty both BEFORE and AFTER all three invocations,
budget/quota-fit/ still does not exist (no path history), and config/budget-pools
is byte-identical to its 2026-09-05T11:45:49Z commit (af74d8fa76). All three fits
exited 0 (no crash). Both anthropic hosts grade CONVERGED with fresh-window fits
ABOVE their actuated caps, yet the caps stayed put — promotion remains a separate
deliberate act (set-budget-pool.sh), exactly as designed. No defect found; no
fixer job posted.
