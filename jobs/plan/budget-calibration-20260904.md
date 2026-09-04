---
gate: orchestrated
orchestrated_by: budget-calibration-orch-20260904
priority: normal
posted_by: producer
posted_at: 2026-09-04T22:03:48Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Calibrate the fleet's weekly Anthropic token budget from the human-verified
dashboard-vs-meter checkpoint log (`journal/budget/manual-checkpoints/*.jsonl` and
its README) plus `journal/budget/reset-events/*.jsonl`, for both pools
(`endolin-garden-ece02cb4`, `endolin-garden2-5bcdff64`).

Fit the slope of meter spend vs. dashboard `weekly_percent` per host/account and
extrapolate to the 100%-spent intercept to estimate each account's real weekly
token cap, for the time remaining until its confirmed reset (Friday 8pm Pacific /
2026-09-05T03:00Z for both, per the log). Watch the documented confounds before
trusting a single ratio:

- `endolin-garden-ece02cb4` already shows THREE mutually incompatible
  same-nominal-`window_start_epoch` clusters (~150-159M, ~482-570M, ~179-606M —
  see the checkpoints README's "wildly different implied caps" note and the
  reset-events log's window-anchor-oscillation history). Justify which cluster
  (if any) is trustworthy rather than averaging across incompatible regimes.
- The 2026-09-04T21:57Z checkpoint shows the DASHBOARD percent crashing 56%->5%
  while the local meter kept accumulating with no window reset. Its own note
  flags the naive implied cap (1.92B) as untrustworthy — do not use it as a real
  data point.

Write the resulting cap(s) into `journal/config/budget-pools` with real
`calibrated_from`/`calibrated_at` provenance. Today both Anthropic pool rows have
NO provenance columns filled in at all (only prose in the header comments), so
`budget-level.sh` has logged `... is UNCALIBRATED; leveling nothing` on every
scheduler tick since the 2026-09-03 recalibration — worker counts have not been
auto-adjusting off any of this. Fix that gap as part of landing the recalibration.

**New scope (maintainer, 2026-09-04):** a subscription-backed host's admission/
leveling pace should be gated by the LESSER of the weekly cap's remaining-pace and
the SESSION-scoped (5-hour rolling) quota's pace. `config/budget-pools` has no
column for the session dimension today (its own header already flags this gap).
Design how to represent and calibrate that second constraint — survey
`designs/live-budget-admission.md`, `designs/recurring-budget-calibration.md`, and
`designs/quota-throttle.md` for prior art before inventing a new mechanism. If a
full actuation change is too large for this job, land the weekly recalibration +
provenance fix now and write the session-cap mechanism up as a short
`designs/*.md` addendum naming it as an open question for the maintainer — but do
not skip addressing it.

Write your findings (the regression, the chosen caps and why, the session-cap
design decision or open question) clearly into your tada report — a follow-up job
turns it into a maintainer-facing report published as a minion.town clip.
