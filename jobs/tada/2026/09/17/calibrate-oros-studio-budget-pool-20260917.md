Everything is verified. All four deliverables are committed and pushed to `origin/journal2`; the reset window, meter anchor, and single-row integrity all check out. The prior attempt completed the job correctly before the requeue. No further edits are needed — re-appending or re-promoting would only create duplicates.

## Completion report

**Status: already complete.** A prior attempt of this job finished all four tasks and pushed them to `origin/journal2` before the reaper requeue; I re-derived the state, verified it against the authoritative branch, and confirmed it is correct and duplicate-free. No new commits were required.

**What is in place on `origin/journal2`:**

1. **Meter sampled** — `meter_spend_tokens: 5,748,899` at `2026-09-17T02:10:46Z`, ~6 min after the maintainer's `02:04:54Z` dashboard read. Billable basis (input+output+cache_creation, excludes cache_read), per `usage-meter.sh`.

2. **Checkpoint appended** — single row in `budget/manual-checkpoints/oros-studio-garden-ce242c49.jsonl` (confirmed exactly one row, no requeue duplicate): `weekly_percent 7`, `session_percent 3`, `weekly_resets_at 2026-09-22T10:00:00Z` (verified Tuesday 04:00 MDT = 10:00Z; window start 2026-09-15 also verified Tuesday), `pairing_confidence "low"`.

3. **Plan facts recorded** — notes state Max 20x, **usage credits OFF**, and explicitly that the pool is *structurally immune* to the $1,090 endolin-garden2 metered-spill failure (it stops at the cap, cannot spill into metered billing).

4. **`budget/live/oros-studio-garden-ce242c49` established** — live and refreshing (status `ok`, last sample `2026-09-17T03:00:20Z`), so the host now appears in the leveling and claim-gate machinery like its two siblings.

**Confound handling (why the pairing is honest):** the local meter anchors on Friday 20:00 Pacific (`window_start_epoch 1789182000` = Sat 03:00Z), *not* the true Tuesday reset. The prior attempt correctly paired the 7% dashboard reading against the Tuesday-window spend (5,506,103), not the raw Friday-anchored figure.

**Implied cap & decision:**
- Point estimate ≈ 78.7M (Tue-window / 0.07); conservative low-end ≈ 73.4M (Tue-window / 0.075).
- **Promoted**: `anthropic:oros-studio-garden-ce242c49 = 73,000,000 weekly-tokens`, provenance **`manual-single-point-fresh-pair`**, `calibrated_at 2026-09-17T02:06:49Z`.
- **Confidence: LOW** — single point, no prior row to regress against, ~6-min read/sample gap across the Friday/Tuesday anchor confound.
- This is a **real calibrated provenance** (not in the fail-closed uncalibrated set), so the claim gate admits at full authority rather than halting the host. The foot-gun (writing a placeholder → halt) was correctly avoided.

**Sanity check — in family.** 73M sits between the calibrated siblings (endolin-garden2 64M, endolin-garden 143M) and matches the maintainer's own 35–40%/week projection: 2 gardeners over ~30h → 7%, extrapolating to ~39% over a 168h week. Not out of family; the single point is weak but plausible, consistent with promoting the conservative low-end rather than the point estimate.

**Worker-count guidance (for the throttle-raise decision):** at 73M cap, current 2 gardeners project to ~35–40% weekly utilization. To reach **70–80% weekly utilization, ~4 gardeners** (roughly double the current 2) — per-gardener draw is ~14–15M tokens/week, and 75% of 73M ≈ 54.75M / ~14.2M ≈ 3.9 gardeners. So raising from 2 to 4 gardeners is the calibrated headroom; going beyond ~4 risks hitting the hard cap (no metered spill, so it would starve claims rather than overspend).

**Follow-up:** confidence stays LOW until a second fresh paired point accrues on the *same* meter anchor. A promotion to `converged` (per `fit-quota-calibration.sh`) needs ≥3 same-anchor points with internal spread ≤1.20x, no active boost, and the live anchor matching — none of which a single point can satisfy. Keep appending checkpoints on future maintainer readings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/calibrate-oros-studio-budget-pool-20260917.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 46 tokens (1638717 cached reads)
- Output: 33832 tokens
- Cost: $3.0655585
- Wall-clock: 553s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
