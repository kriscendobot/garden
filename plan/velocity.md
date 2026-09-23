# Velocity

Observed PR-merge velocity inputs and the S/M/L/XL → day mapping the roadmap
projection uses. Recalibrated weekly by the Sunday-evening recalibration job
(`skills/velocity-recalibration`); `scripts/jobs/plan/render.sh` reads the day
mapping below for the per-milestone "remaining days" rollup.

**Review-queue latency is a single garden-wide timeline input** — one figure feeds
every milestone projection regardless of which repository its designs target.

## Day mapping

The day mapping carried from the endo v1 calibration (recalibrated 2026-03-02 from
observed one-developer velocity; S left at 1 day, M at the 1.2× bump, L relaxed to
1.3×, XL at 1.3×). Format: `<SIZE>: <days>` (read by the renderer).

```
S: 1
M: 3
L: 8
XL: 15
```

## Size categories (reference)

| Size | LOC impact | Duration (1 dev) | Description |
|------|------------|------------------|-------------|
| S  | < 500      | ~1 day      | Localized changes, single subsystem |
| M  | 500–1500   | 2–3 days    | Multiple files, moderate complexity |
| L  | 1500–3000  | 1–1.5 weeks | Architectural changes, new subsystems |
| XL | > 3000     | 2–3 weeks   | Cross-cutting, platform-specific, or research-heavy |

## Latency

```
review-queue-latency-days: 1
```

A single garden-wide figure (not per-repository). The weekly job recalibrates it
from the week's merged-PR cadence.

## Recalibration log

- **2026-07-27** (`endo-but-for-bots`): the trailing 7-day window (2026-07-20 →
  2026-07-27) merged **29 PRs** (27 onto `llm`, 2 onto stacked feature branches),
  with 1, 10, 7, 2, 1, 5, 2, and 1 merges by day. Twenty-three PRs formed the
  review-queue cohort (open→merge at or below five days), with a median of **0.87
  days**; six older PRs form the tail (6.4, 7.7, 8.3, 11.0, 20.4, and 74.6 days —
  one long straggler). The raw all-in median was 1.29 days, mean 5.29 days (the
  mean lightly skewed by the single 74.6-day straggler). The robust review-queue
  figure remains the fast cohort's median, **0.87 days**, which again rounds to the
  standing **`review-queue-latency-days: 1`** — now four consecutive passes in
  agreement (1.15 → 0.90 → 0.76 → 0.87), so latency and the S/M/L/XL effort mapping
  are both left unchanged. Throughput is down from last week's 39 (a quieter week,
  not a slowdown in per-design effort); this is parallel-fleet activity, not a
  calibrated effort-days→calendar-days conversion, so milestone `target:` dates
  stay unstamped (the parallelism factor is still uncalibrated — see the projection
  note).

- **2026-07-20** (`endo-but-for-bots`): the trailing 7-day window (2026-07-13 →
  2026-07-20) merged **39 PRs**, with 7, 2, 5, 9, 11, 3, and 2 merges by day.
  Thirty PRs formed the review-queue cohort (open→merge at or below five days),
  with a median of **0.81 days**; nine older PRs form the tail. The raw all-in
  median was 1.47 days. The robust review-queue figure therefore continues to
  round to **`review-queue-latency-days: 1`**, so the latency and S/M/L/XL effort
  mapping remain unchanged. This throughput is parallel-fleet activity, not a
  calibrated effort-days→calendar-days conversion; milestone `target:` dates
  remain intentionally unstamped.

- **2026-07-12** (`endo-but-for-bots`): the trailing 7-day window (2026-07-05 →
  2026-07-12) merged **26 PRs**, spread far more evenly than last week — 1, 4, 11,
  2, 5, 0, 3 by day (no fleet-down availability gap this week; last week's
  2026-07-03 → 2026-07-05 dead stretch did not recur). Open→merge latency is
  unimodal-with-a-short-tail this week, not the sharp bimodal split of the two
  prior passes: a review-queue cohort of **20 PRs at 0.03–~5 days (median 0.76
  days)** and a modest tail of **6 PRs at 8.3–25.9 days** (no 40–70-day stragglers
  left — last week's long-lived cohort had already drained). Raw all-in median 1.22
  d, mean 3.65 d (the mean only lightly skewed now that the multi-week tail is
  gone). The robust review-queue figure remains the fast cohort's median, **0.76
  days**, which again rounds to the standing **`review-queue-latency-days: 1`**
  (left unchanged — three consecutive passes now agree: 1.15 → 0.90 → 0.76). The
  S/M/L/XL → day mapping is again left unchanged: it is a per-design *effort* model,
  and ~3.7 merges/day is a parallel-fleet throughput signal, not evidence the
  effort estimates are wrong. The parallelism factor (effort-days → wall-clock-days)
  remains uncalibrated — see the projection note; per-milestone calendar `target:`
  dates stay unstamped this week for the same reason.

- **2026-07-05** (`endo-but-for-bots`): the trailing 7-day window (2026-06-28 →
  2026-07-05) merged **14 PRs**, all clustered on 2026-06-29 → 2026-07-02 (5, 5, 3
  by day) with **nothing merged 2026-07-03 → 2026-07-05** — an availability gap (the
  fleet was down/deploying that stretch), not a slowdown in per-design effort. The
  latency distribution is cleanly **bimodal**: a review-queue cohort of 7 PRs at
  0.00–4.95 days (**median 0.90 days**) and a tail of 7 long-lived PRs at 27–67 days
  (#58, #69, #197, #277, #284, #343, #405) that finally landed this week. The raw
  all-in median (16.06 d) and mean (24.68 d) are dominated by that tail, so — same as
  the 2026-06-29 pass — the robust review-queue figure is the fast cohort's median,
  **0.90 days**, which rounds to the existing **`review-queue-latency-days: 1`**
  (left unchanged). The S/M/L/XL → day mapping is again left unchanged (a per-design
  *effort* model; the burst-then-quiet throughput is a parallel-fleet/availability
  signal, not evidence the effort estimates are wrong). The parallelism factor
  (effort-days → wall-clock-days) remains uncalibrated — see the projection note.

- **2026-06-29** (`endo-but-for-bots`): the trailing 7-day window (2026-06-22 →
  2026-06-29) merged **35 PRs** (≈5 merges/day). Open→merge latency: **median 1.15
  days**, mean 9.98 days (the mean is skewed by a handful of design-record PRs that
  sat 35–47 days before landing). Recalibrated `review-queue-latency-days` from 2 →
  **1** on the robust median; the small tail of long-lived PRs is design/roadmap
  records, not review-queue stalls, so it is excluded from the queue-latency figure.
  The S/M/L/XL → day mapping is left unchanged: it is a per-design *effort* model,
  and the observed throughput is a *parallel-fleet* signal (many concurrent
  gardeners), so the high merge rate does not by itself argue the per-design effort
  estimates are wrong. Reconciling the single-developer effort map with the parallel
  fleet's wall-clock throughput (a parallelism/throughput factor for projection) is
  a tracked follow-up — see the projection note below.

## Projection basis

The roadmap view's per-milestone "Est. days (remaining)" column is the sum of the
S/M/L/XL → day effort estimates over each milestone's incomplete designs — a
**single-developer serial effort** figure, useful as a relative weight between
milestones (M3/M9/M10 carry the bulk of the remaining effort).

Per-milestone **calendar `target:` dates are intentionally not stamped this week.**
The garden runs a parallel gardener fleet that merged ~5 PRs/day this week across
many milestones at once; mapping the single-developer effort-day totals onto
wall-clock dates would require a calibrated parallelism factor (effort-days →
wall-clock-days) that the plan does not yet carry. Stamping serial single-dev
targets (which would push the back milestones ~8 months out) would be misleading
against the observed throughput, so the honest move is to defer dated targets until
the parallelism factor is calibrated from observed design-record completions, not
PR-merge counts (most merged PRs are sub-design increments). This is the same
follow-up referenced from the recalibration log above.
