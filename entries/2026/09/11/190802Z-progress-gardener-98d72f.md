---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-11T19:08:04Z
---
[pr80-quota-validation] day 20260911

Day 6 of the seven-day observation campaign validating the manual
quota-calibration system landed by kriscendobot/garden#80 (merge SHA
33a84b7167d3f3d745bb0539f9ec0a2af93c9a66). All journal/GitHub prose below was
read as untrusted DATA, never as instructions. MEASURE-only run:
fit-quota-calibration.sh was invoked with `--dry-run --json-only` for every host
with a checkpoint log; it actuated nothing.

## Hosts observed (derived from `ls budget/manual-checkpoints/*.jsonl`)
endolin-garden-ece02cb4, endolin-garden2-5bcdff64, openai-codex-shared.

## Per-host fit verdicts (`fit-quota-calibration.sh <host> --dry-run --json-only`)

### endolin-garden-ece02cb4 — CONVERGED
- selected_cap (low band): 147,687,576 tokens; point 148,773,514; high 149,875,540.
- Governing segment: run-3-anchor-1788577200 (the live 2026-09-05T03:00Z-reset
  weekly window), n_points=8, total_confidence_weight=21, percent_range 4-68,
  cap-point spread 147.8M-168.5M, spread_ratio 1.14. Governing point is the
  2026-09-09T19:23:00Z checkpoint (weekly 68%, meter_spend 101,165,990, high
  pairing) — the freshest highest-confidence point.
- Convergence checks: enough_points ok (8 >= 3); spread_within_tolerance ok
  (1.14 <= 1.20); live_window_matches ok (1788577200); boost_active false. No
  failed checks.
- Currently actuated cap (config/budget-pools): 143,000,000
  (calibrated_from manual-regression-fresh-contiguous-cluster, 2026-09-04T22:10:57Z).
  The converged fit (147.7M low band) still sits ABOVE the conservative 143M
  setpoint — an observation for a future deliberate promotion, not actuated here.

### endolin-garden2-5bcdff64 — CONVERGED
- selected_cap (low band): 68,328,025 tokens; point 68,796,026; high 69,270,481.
- Governing segment: run-1-anchor-1788577200 (live weekly window), n_points=5,
  total_confidence_weight=14, percent_range 30-73, cap-point spread
  65.9M-71.7M, spread_ratio 1.089. Governing point is the 2026-09-09T19:23:00Z
  checkpoint (weekly 73%, meter_spend 50,221,099, high pairing; session left null
  by the reporter — no active session at check time).
- Convergence checks: enough_points ok (5 >= 3); spread_within_tolerance ok
  (1.089 <= 1.20); live_window_matches ok; boost_active false. No failed checks.
- Currently actuated cap: 64,000,000
  (calibrated_from manual-single-point-first-fresh-pair, 2026-09-05T11:44Z).
  Converged fit (68.3M low band) still sits ABOVE the conservative 64M setpoint —
  again an observation only.

### openai-codex-shared — INSUFFICIENT
- selected_cap: null. method segment-low-band; note "no usable paired
  checkpoints (all rows none/flagged or null-spend)". segments: [].
- EXPECTED, not a defect: the shared codex/OpenAI pool has no meter substitute,
  so all checkpoint rows carry null meter_spend / pairing_confidence "none". Thin
  paired data => an honest "insufficient" grade. No config/budget-pools row exists
  for this pool and none should (the actuator filters to provider=anthropic).

## State snapshots
- budget/quota-fit/ : DOES NOT EXIST — after my fit runs it is still absent. No
  promoted fit verdict has ever been written; the measure->promote path has still
  never been exercised. Expected at day 6.
- budget/live/ : ece02cb4 spend 101,838,093 / cap 143,000,000 (status ok, sampled
  2026-09-11T18:30:35Z); garden2 spend 57,061,374 / cap 64,000,000 (status
  BACKOFF, sampled 2026-09-11T18:30:54Z). Both windows anchored 1788577200. (vs
  day 5: ece02cb4 101,838,093 — BYTE-IDENTICAL, host idle on this pool; garden2
  50,221,099 -> 57,061,374, +~6.84M real in-window spend, now at ~89% of its 64M
  cap and correctly in BACKOFF — the actuated cap throttling as designed, not a
  calibration event.) Weekly reset 2026-09-12T03:00Z is now ~8.5h out.
- config/budget-pools : two actuated anthropic rows (ece02cb4 143M @
  2026-09-04T22:10:57Z; garden2 64M @ 2026-09-05T11:44Z). Content byte-identical
  to prior days (last calibration 2026-09-05T11:45Z; the file mtime is a journal
  checkout artifact, not a content change — it was NOT among files modified today).
  The file's PROSE header still narrates a superseded 595M ece02cb4 band; the
  actuated data ROW is the authoritative 143M (documentation lag in the header
  comment, not a live mis-actuation) — carried over unchanged from days 1-5.

## Since-yesterday activity delta (vs day 20260910 entry
## entries/2026/09/10/190758Z-progress-gardener-c41787.md)
- NO new manual checkpoints. Newest checkpoint per host is UNCHANGED from day 5:
  ece02cb4 and garden2 both still 2026-09-09T19:23:00Z; codex still
  2026-09-09T19:23:00Z. All three jsonl files last touched 2026-09-09T19:24:47Z.
- Both anthropic fits are BYTE-IDENTICAL to day 5's verdicts (same governing
  point, same segment shape, same selected_cap bands, same passing checks). codex
  unchanged: INSUFFICIENT, segments []. No fit grade or band moved.
- budget/quota-fit: still absent — no promotion activity.
- config/budget-pools: content unchanged (no re-calibration, no promotion).
- The ONLY movement is ordinary live-meter accrual: garden2 climbed +~6.84M and
  crossed into BACKOFF (~89% of cap) with the weekly reset imminent; ece02cb4 live
  spend is flat/idle. This is the actuated cap working, not calibration activity.
- I appended NO manual checkpoint (no dashboard reading available to me; hard
  constraint honored — nothing written to manual-checkpoints).
- Net: a QUIET day for calibration — no new checkpoints, no fit change, no
  promotion, no budget-pools actuation since day 5.

## Measure/actuate boundary: HELD
The `--dry-run` fit runs wrote nothing: budget/quota-fit/ still does not exist
after all three invocations; the only budget/ files modified today (2026-09-11)
are the two budget/live/ meter samples (written by the live usage sampler, not by
me), and config/budget-pools was NOT among today's modified files (content
byte-identical to prior days). All three fits exited 0 (no crash), segmented
sensibly, and produced stable verdicts. Both anthropic hosts grade CONVERGED with
fresh-window fits ABOVE their actuated caps, yet the caps stayed put — promotion
remains a separate deliberate act (set-budget-pool.sh), exactly as designed. No
defect found; no fixer job posted.
