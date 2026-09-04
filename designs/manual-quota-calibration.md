# Grounding rate-limiting cybernetics in the manual quota-checkpoint log

| | |
| --- | --- |
| Created | 2026-09-04 |
| Author | designer (gardener, job `design-manual-quota-calibration`) |
| Status | Proposed |
| Directive | kriskowal 2026-09-03: *"create or obtain a record for all of my manually verified quota checkpoints, against a record of token usage over time, so we can gradually increase our confidence in our tokens per quota ratio, to ground our cybernetics around rate limiting jobs."* |
| Composes with | [`recurring-budget-calibration.md`](recurring-budget-calibration.md), [`cybernetics-audit.md`](cybernetics-audit.md) § 2.1 / § 2.3 / § 7 rec 2 |

The fleet regulates "how much of the provider's weekly allowance remains" but no
loop measures that quantity directly (`cybernetics-audit.md` § 2.1). The one
authoritative reading of it — the Claude dashboard's weekly-limit percentage — is
not machine-readable, so a human reads it and states a number. The manual
quota-checkpoint log (`journal/budget/manual-checkpoints/<host>.jsonl`, already
created and seeded) is the record of those human readings, each paired where
possible with the simultaneous local token-meter spend. This design says how the
fleet **uses** that log to ground the cap the leveling controller and the claim
gate act on, without letting a shaky number silently actuate.

It is a **separate document from** [`recurring-budget-calibration.md`](recurring-budget-calibration.md)
and composes with it (last section). That document calibrates real-versus-notional
*dollar* cost automatically from a configured subscription price and never reads a
human percentage; this one is the human-verified *percent-to-token* calibration it
does not attempt. Two different sensors on the same plant, decided independently.

## 1. Why a single ratio cannot be trusted, and what the fit does instead

The log's first day already disproves the simplest model. A constant
tokens-per-percent ratio predicts every paired point on one account implies the
same weekly cap. They do not: the governing series spans roughly 157M to 606M
implied cap — a ~3.9x spread (reproduced exactly by the fit script below, whose
`spread_ratio` for that segment is 3.868). Three confounds, all documented in the
log's own README, drive that spread, and no single-point recalibration can see any
of them:

1. **Base mismatch.** The local meter counts `input + output + cache_creation` and
   **excludes `cache_read`** (`usage-meter.sh`); the dashboard's weighted percentage
   does not exclude cache reads the same way. The ratio therefore drifts with the
   workload's cache-read mix.
2. **A temporary +50% weekly boost** through 2026-09-13, with an **unknown start
   time**. A checkpoint taken after the boost began measures a genuinely higher true
   cap than one taken before, with no measurement error at all — and the ratio in
   effect today drops by roughly a third when the boost expires.
3. **Meter-anchor oscillation.** The local meter's `window_start_epoch` flip-flops
   between two fixed anchors. When it moves forward the summed window shortens and
   `meter_spend_tokens` swings sharply, independent of real usage. Rows on either
   side of an anchor change are **not comparable** and must never be ratio'd across
   the boundary.

**The fitting approach — `fit-quota-calibration.sh`, deterministic, no LLM.** Given
those confounds, the honest method is not a clever regression over one messy day but
a disciplined selection that refuses to converge on noise:

- **Drop unusable rows.** A row with `pairing_confidence` of `none`/`flagged` or a
  null `meter_spend_tokens` records a percentage for history but carries no usable
  pairing; the fit ignores it.
- **Segment by the hard comparability boundary.** Group the remaining points by
  `meter_window_start_epoch`. Only points sharing an anchor are ratio-comparable
  (confound 3). Each point's conservative cap estimate is the **low end of its
  display-rounding band**, `spend / ((percent + 0.5) / 100)` — the same "cannot
  over-grant, take the low end" policy `config/budget-pools` already applies by hand.
- **Pick a governing segment** by total confidence weight (`high`=3, `medium`=2,
  `low`=1), then recency of its newest point, then point count. Within it, the
  **governing point** is the freshest highest-confidence reading, and the selected
  cap is that point's low-end band.
- **Grade the result** `converged` / `provisional` / `insufficient`:
  - `converged` only when the governing segment has at least `MIN_POINTS` (default 3)
    points, its internal point-estimate spread is within tolerance (default max/min
    ≤ 1.20), **no boost confound is active**, and the governing anchor **is the one
    the meter is publishing live right now**. Only a `converged` fit is a candidate
    for promotion to a trusted cap.
  - `provisional` when there are enough points but the spread, a live boost, or a
    stale anchor blocks convergence. Recorded, never promoted as trusted.
  - `insufficient` otherwise.

Run against today's seed the fit selects 595,704,540 — the exact low-end-of-28%
figure the maintainer set `config/budget-pools` to by hand — and grades it
**`provisional`**, because the governing segment's spread is 3.868x. That is the
design working: it independently reproduces the human's conservative choice **and**
refuses to certify it as converged. The verdict JSON also carries every segment's
summary and a `checks` object naming exactly which gate failed, so the reason a fit
is not trusted is legible rather than a bare grade.

**On modelling cache-read separately.** The local meter already has `cache_read_tokens`
in its `usage/*.jsonl` CostRecords, so a richer two-coefficient fit (regress the
dashboard percentage against `billable_excluding_cache_read` and `cache_read`
separately, recovering the dashboard's implicit cache-read weight) is the eventual
way to dissolve confound 1. But that fit needs each checkpoint to carry the paired
`cache_read` total at sample time, which the **current checkpoint schema does not
capture** (it stores only `meter_spend_tokens`, cache-read excluded). Pretending to
fit a two-parameter model from data missing its second variable would be dishonest.
So the staging is explicit: the single-coefficient segmented fit ships now and
stays deliberately `provisional` while the confounds dominate; the checkpoint
schema gains an optional `meter_cache_read_tokens` field (auto-filled from the same
`budget/live` snapshot once `usage-meter.sh` publishes it), and the two-coefficient
fit becomes a later, additive mode of the same script once enough cache-read-paired
points accrue. This design does not build that second mode; it reserves the field
and names the trigger.

## 2. How a fit feeds `config/budget-pools` — human-in-the-loop, never auto-actuated

The fit **measures and records; it does not actuate.** It writes its verdict to
`budget/quota-fit/<host>.json` and never touches `config/budget-pools`. This is the
same measure/actuate boundary `weekly-capacity-calibration.sh` already draws for the
automatic ledger, and for the same reason `cybernetics-audit.md` § 2.3 gives: do not
wire an auto-derived setpoint straight to a full-authority actuator.

Promotion into `config/budget-pools` stays a **deliberate act** through a new
`set-budget-pool.sh <pool> <ceiling> <calibrated_from> [date] [--kind ...]`, invoked
by a human or a proxy role when the log has enough new points and the fit reads
`converged`. The setter writes the provenance columns (`calibrated_from`,
`calibrated_at`) that `cybernetics-rec123-budget-loop` already landed, so a promoted
cap carries `manual-fit <date>` and the leveling controller trusts it, while a cap
left at `placeholder`/absent stays honestly disarmed for leveling.

**A sharp asymmetry this design surfaces and does not paper over.** The uncalibrated
guard `budget_level_uncalibrated` protects only **`budget-level.sh`** (the worker-count
leveler). The **claim gate** — `pool_admits` → `meter_quota_status` — reads only the
`ceiling` column and **never consults provenance**, so any cap written to
`config/budget-pools` arms per-claim admission at full authority regardless of its
provenance marker. Marking a cap uncalibrated therefore neuters leveling but **not**
the gate that actually starved claims fleet-wide in the incident this whole thread
traces back to. The safe consequence, given that asymmetry: a fit graded below
`converged` is **not promoted at all**. The conservative low-end cap already live
stays in place (or the operator unblocks by hand under time pressure, eyes open), and
the log keeps accruing points until a `converged` fit exists. `set-budget-pool.sh`'s
own header states this so nobody promotes a provisional number expecting the
uncalibrated marker to make it safe. Whether the claim gate *should* honor provenance
the way leveling does is a real fork — see Open questions.

## 3. The durable ingestion point — `append-quota-checkpoint.sh`

`append-quota-checkpoint.sh <host> <weekly_percent> [session_percent]` replaces the
hand-written JSONL row. It reads the current `budget/live/<host>` snapshot and
auto-fills `meter_spend_tokens`, `meter_sampled_at`, and `meter_window_start_epoch`
from it, derives `pairing_confidence` from the snapshot's age (never asserting `high`
on its own — that claim requires human knowledge that spend was frozen, available via
`--confidence high`), computes `implied_weekly_cap_tokens`, flags a `window_start_epoch`
change since the prior row inline in `notes`, and CAS-races the row onto the journal
with the same retry discipline `usage-append.sh` uses. A checkpoint becomes one
command instead of a bespoke edit, which is what makes "keep appending checkpoints"
actually happen.

## 4. How this composes with `recurring-budget-calibration.md`

The two calibrations are complementary sensors, and each checks the other:

- The **automatic** ledger's `max-over-trailing-4-weeks billable_tokens` per account
  is a capacity estimate derived with no human in the loop. The **manual** fit's
  `converged` cap is a human-verified cross-check on it: a large disagreement between
  the two is a signal that one sensor is wrong (a boost regime the automatic ledger
  cannot see, or a stale manual reading), not a number to average.
- Both feed the **same** `config/budget-pools` through the **same** deliberate
  `set-budget-pool.sh` setter and the **same** provenance columns, so there is one
  actuation path and one place to read what a cap was calibrated from. Neither
  mechanism writes the config on its own.
- They share the meter-anchor and boost caveats: the automatic ledger's weekly fold
  is windowed on the same reset anchor whose oscillation confound 3 describes, so its
  own records inherit the same "not comparable across an anchor flip" hazard until
  the oscillation is diagnosed and fixed.

Kept separate rather than folded into that document because the fitting problem here
(percent-to-token with three named confounds) is genuinely different work from that
document's dollar-cost calibration, and that document is already at readable length
with its own open questions.

## Build slice (this job ships items 1–3; 4 is reserved)

1. `append-quota-checkpoint.sh` — the ingestion helper (§ 3). **Built in this job.**
2. `fit-quota-calibration.sh` — the segmented, graded fit writing
   `budget/quota-fit/<host>.json` (§ 1). **Built in this job.**
3. `set-budget-pool.sh` — the deliberate provenance-carrying promotion setter (§ 2).
   **Built in this job.**
4. The two-coefficient cache-read-aware fit mode and the `meter_cache_read_tokens`
   checkpoint field. **Reserved**, triggered when `usage-meter.sh` publishes
   cache-read in `budget/live` and enough paired points accrue.

## Open questions

- **Should the claim gate honor cap provenance the way leveling does?** Today
  `meter_quota_status` hard-gates on any cap in `config/budget-pools` regardless of
  its `calibrated_from` marker, so a provisional/uncalibrated cap still throttles
  per-claim admission at full authority — the exact actuator that starved the fleet
  on 2026-09-03. Options: (a) leave it hard-gating and rely on "never promote a
  non-`converged` fit" (this design's current stance); (b) make an uncalibrated cap
  fail **open** at the claim gate too, which removes throttling entirely on an
  uncalibrated pool (the `endolin-garden2` over-quota situation, protection off); or
  (c) a middle setting where an uncalibrated cap gates at a conservative floor. This
  is a genuine safety fork with a real downside on each branch; it belongs to the
  maintainer.
- **Should a `converged` fit ever auto-promote?** This design keeps promotion a
  deliberate human/proxy act even at `converged`. A future once-the-mechanism-has-run
  posture might auto-write the cap past a stricter threshold (more points, a longer
  agreeing history, a bounded per-tick step), reusing the `weekly-capacity-calibration.sh`
  fail-open-to-investigation pattern. Deferred deliberately, not decided here.
- **Is anchor-value grouping enough, or should the fit also split a segment on
  temporal contiguity?** Grouping purely by `meter_window_start_epoch` lumps the
  early `17/19/28%` cluster together with the later `39/40%` cluster because the
  anchor oscillated back to the same value, which inflates that segment's spread and
  (correctly, but coarsely) forces `provisional`. A refinement would split a segment
  wherever the anchor changed and came back. The current behavior fails safe (toward
  `provisional`), so this is a precision improvement, not a correctness fix.
- **Does `endolin-garden2` need its own checkpoint discipline at all while it runs on
  a temporary API key?** It is `unmetered` in `config/budget-pools` today, so no cap
  gates it; its checkpoint log stays useful only as a historical record until the key
  lapses and a real weekly ceiling returns.
