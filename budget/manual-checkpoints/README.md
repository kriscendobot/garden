# Manual quota checkpoints

Append-only log of **human-read Claude dashboard quota percentages**, each
paired (where possible) with the simultaneous `usage-meter.sh` billable-token
spend for that host, so the tokens-per-percent ratio for each account can be
estimated from real data points instead of a single ad hoc snapshot. This is
distinct from and complementary to `designs/recurring-budget-calibration.md`
(the automatic, dollar-cost-calibrated weekly-capacity ledger proposed in
`designs/cybernetics-audit.md` § 7 rec 2) — that mechanism never asks a human
for a percentage at all; it derives real-vs-notional cost purely from
`usage/*.jsonl` plus a configured monthly subscription price. This log is the
missing input for a *human-verified* percent-to-token calibration, which the
existing design does not attempt.

One row per checkpoint, one file per host: `<host>.jsonl`, appended (never
rewritten in place), newest last.

## Row schema

```jsonc
{
  "checked_at": "2026-09-03T20:57:00Z",   // approx wall-clock time of the human's dashboard read
  "host": "endolin-garden-ece02cb4",
  "reported_by": "kriskowal",
  "weekly_percent": 28,                    // integer, as displayed by the Claude dashboard/CLI
  "weekly_resets_at": "2026-09-05T03:00:00Z",
  "session_percent": 3,                    // optional: the separate 5-hour rolling session limit, if given
  "session_resets_at": "2026-09-04T00:41:00Z",
  "meter_spend_tokens": 169775794,         // usage-meter.sh billable-token spend closest in time to checked_at
  "meter_sampled_at": "2026-09-03T20:47:12Z",
  "meter_window_start_epoch": 1788286674,  // budget/live's window_start_epoch at sample time -- compare across
                                            // rows before ratio'ing two of them; a mismatch means they are not
                                            // in the same meter window and are NOT comparable
  "pairing_confidence": "high",            // high | medium | low | none -- see below
  "implied_weekly_cap_tokens": 606342121,  // meter_spend_tokens / (weekly_percent/100), when pairing_confidence
                                            // is not "none"; the number a single-point calibration would use
  "notes": "free text"
}
```

`pairing_confidence`:
- **high** — spend is known NOT to have moved between the meter sample and the
  dashboard read (e.g. claim-job.sh was actively refusing every claim, or the
  two were within a couple minutes with no active work).
- **medium** — sample and read are within roughly 15 minutes with normal fleet
  activity in between; some slop.
- **low** — sample and read are loosely time-matched, or the meter window was
  independently observed to be unstable around this time.
- **none** — no usable simultaneous meter sample exists; the row records the
  human-verified percentage alone for the historical record.

## What the first four points already show (2026-09-03)

`endolin-garden-ece02cb4`'s three same-window paired points (`meter_window_start_epoch`
1788286674 throughout) give **wildly different implied caps**: ~192-204M at 17%,
~175-184M at 19%, but ~596-617M at 28%. If the true weekly cap were a fixed
number, these should roughly agree — they don't, by a factor of ~3x. The likely
cause is the base mismatch this repo's own docs already flag (`config/budget-pools`
header): the local meter counts `input + output + cache_creation` and **excludes
`cache_read`**, while the Anthropic dashboard's weighted percentage almost
certainly does not exclude (or does not weight identically) cache reads. The
period between the 19% and 28% readings was a large backlog-clearing burst
(dozens of PR gauntlet/panel/fix jobs) with a plausibly very different
cache-read/cache-write mix than the lighter period before it — exactly the
"workload mix stays broadly similar" caveat `config/budget-pools`'s own header
already warns a ratio calibration depends on.

**Practical consequence:** do not treat any single-point-derived cap (including
the 595M currently live in `config/budget-pools` as of this row's `checked_at`,
derived from the highest-confidence point available at the time) as converged.
Recalibrate from the *freshest, highest-confidence* point when self-throttling
recurs, and keep appending checkpoints — enough of them, across enough
different workload mixes, should let a future pass fit something better than a
constant ratio (e.g. separate cache-read/cache-write coefficients) instead of
re-deriving one brittle point estimate each time. That fitting work itself is
not done here; see the follow-up job posted alongside this log.

## A confound discovered 2026-09-03T21:31Z: a temporary plan-wide boost

The 5th checkpoint (2026-09-03T21:31Z, the first sourced from an actual page
HTML dump rather than a verbal report) surfaced a banner on the dashboard
itself: *"Your limits are temporarily boosted. Your weekly Claude Code limit
is 50% higher through September 13."* **Start time unknown** — the page names
only the end date. If this boost only took effect partway through today, it
alone could account for much or all of the ~3x spread described above,
independent of (or on top of) the cache_read theory: any checkpoint taken
*after* the boost started would show a genuinely higher true cap than one
taken *before* it, with no measurement error involved at all. This is now the
leading candidate explanation and should be checked before assuming a
cache-read-weighting fix is the right model. Any future fitting pass MUST
either confirm the boost was constant across all of today's checkpoints (in
which case it doesn't explain the spread) or bound when it started (in which
case pre- and post-boost checkpoints need separate ratios, and the ratio in
effect right now will itself drop by roughly a third around 2026-09-13 when
the boost expires — do not extrapolate today's calibration past that date
without accounting for it).
