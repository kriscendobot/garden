---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: host=oros-studio-garden-ce242c49
handler-timeout: 1800
---
Calibrate the budget pool for THIS host (oros-studio-garden-ce242c49) from a fresh
maintainer quota reading. This is the host's FIRST calibration: it currently has
NO entry in journal `config/budget-pools`, NO `budget/live/` record, and NO
`budget/manual-checkpoints/<host>.jsonl` file, despite running production work
(gauntlets, weaves, deploys). Follow the measure/actuate boundary in
designs/manual-quota-calibration.md.

## The maintainer's reading (kriskowal, 2026-09-17, reported via the liaison)

- weekly_percent: 7
- weekly reset: Tuesday 04:00 America/Denver (Mountain). In September that is MDT
  (UTC-6), so 10:00Z Tuesday — verify and record the actual window start rather
  than assuming.
- session_percent: 3 (the 5-hour rolling session limit)
- Plan: Max 20x, **usage credits OFF** — the account STOPS at the cap rather than
  spilling into metered billing.
- Maintainer's own projection: roughly 30 hours of running with 2 gardeners
  produced that 7%, so a full week at the current throttle lands around 35-40%.

## Tasks

1. SAMPLE THE METER NOW, as close in time to this reading as you can, using
   `usage-meter.sh`'s billable-token spend for this host. Remember the basis
   difference the config file documents: this meter counts input + output +
   cache_creation and EXCLUDES cache_read, while /usage reports Anthropic's own
   weighted limit. The calibration is a ratio over one shared window and holds
   only while the workload mix stays broadly similar.
2. APPEND a row to `budget/manual-checkpoints/oros-studio-garden-ce242c49.jsonl`
   (create the file) in the documented schema: checked_at, host,
   reported_by "kriskowal", weekly_percent 7, weekly_resets_at, session_percent 3,
   meter_spend_tokens, meter_sampled_at, meter_window_start_epoch,
   pairing_confidence, implied_weekly_cap_tokens, notes. Grade
   `pairing_confidence` HONESTLY — the meter sample is being taken some time after
   the human's dashboard read, and this is a single point with no prior row to
   regress against.
3. Record the plan facts in `notes`: Max 20x, usage credits OFF. This matters
   beyond bookkeeping — it means this pool CANNOT spill into metered billing, which
   is exactly the failure mode that cost $1,090 in one 19h window on
   endolin-garden2 (reports/credit-investigation-endolin-garden2-20260905.md).
   oros-studio is structurally immune to that, and the record should say so.
4. Establish the `budget/live/oros-studio-garden-ce242c49` record so this host
   appears in the leveling and claim-gate machinery at all, as the other two hosts do.

## The actuation decision — READ THIS BEFORE WRITING A POOL ENTRY

Promote a cap with `set-budget-pool.sh` ONLY if the fit genuinely supports it.
There is a sharp foot-gun here, new as of today:

Since `credit-controls-fail-closed-pools` landed, the CLAIM gate consults both
ceiling_kind and provenance and FAILS CLOSED on an untrustworthy pool. A pool
whose provenance is in the uncalibrated set (placeholder / uncalibrated / seed /
tbd / todo / none / '-' / '') now REFUSES EVERY CLAIM rather than admitting at
full authority. So writing a placeholder entry would HALT this host outright,
whereas today — with no entry at all — it claims normally (verified: it claimed
`weave-ebfb-1100-pin-merge-base-20260916` at 2026-09-17T00:01:52Z).

Therefore: promote a REAL calibrated provenance (e.g. `manual-single-point-fresh-pair`,
matching how anthropic:endolin-garden2-5bcdff64 was first calibrated), or promote
NOTHING and report what a second data point would need to look like. Do NOT write
a placeholder. If you judge the single point too weak to promote, say so plainly —
leaving the host ungated for another day is the safer error than halting it.

## Sanity check your result

A 7% reading against ~30h of 2-gardener running implies a fairly large weekly cap.
Compare the implied figure against the two calibrated siblings for plausibility —
anthropic:endolin-garden-ece02cb4 at 143,000,000 and
anthropic:endolin-garden2-5bcdff64 at 64,000,000 weekly tokens — and against the
maintainer's own 35-40%/week projection. If your implied cap is wildly out of
family with those, that is evidence the pairing is bad, not that the host is
enormous. Say so rather than promoting it.

Report the implied cap, the confidence grade, whether you promoted, and — since
the maintainer is weighing whether to raise this host's throttle — what worker
count the calibrated cap would sustain at roughly 70-80% weekly utilization.

<!-- garden-transient-elapsed: kind=signature through=0 values=438 -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T02:04:54Z
