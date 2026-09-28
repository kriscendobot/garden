---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: pacing ignores a maintainer-planned (expected-next-scheduled) reset

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR). Maintainer-approved
(kriskowal, 2026-09-28).

## Problem
The maintainer plans a manual mid-week reset of both Claude subscriptions at **Tue 2026-09-29 20:00
America/Los_Angeles (2026-09-30T03:00Z)**, several days before their calendar reset (Fri 20:00 PT). It's
recorded as `event_type: expected-next-scheduled`, `reset_at_precision: scheduled` rows in
`journal/budget/reset-events/claude-endolin{1,2}.jsonl` (the 2026-09-28T04:00Z rows; an earlier 09-26 row
said 23:59 PT, day-only). The intent, stated in those rows: *accelerate usage against this shorter window
instead of the natural Friday boundary.* But `scripts/jobs/usage-meter.sh` (~line 150) explicitly drops
`expected-next-scheduled` rows when it derives the policy and deadline, so `subscription_pacing_bias` and
the budget leveler (`budget-level.sh`) still pace against Friday. Result: at 2026-09-28 04:00Z,
claude-endolin1 was at 19% and claude-endolin2 at 12%, on track to finish the effective window at only
~37% and ~24%, leaving most of the quota unused.

## Ask
1. Make pacing honor a pending planned reset. When the most recent `expected-next-scheduled` row for a
   subscription has a `reset_at` in the future and earlier than the calendar-derived next reset, use it as
   the window **deadline** for pacing (pace bias, allocation weight, and slack). Once that instant passes,
   fall back to the calendar rule, or to the observed reset when one is recorded. Ignore stale (past)
   planned rows. Ignore a planned row later than the calendar deadline, and say so in the log.
2. Keep the window **start** logic unchanged. Only the deadline moves. A manual reset that actually
   happens should be picked up as an observed reset (by `detect-quota-resets.sh`, or the
   maintainer's next checkpoint) and start the new window.
3. Log the effective deadline and its source (calendar, planned, observed) in the budget-level decision
   reason, so a reader can see why the pacing changed.
4. Tests: a planned reset sooner than the calendar reset raises pace bias and slack compared to the
   calendar-only case; a past planned row is ignored; a later-than-calendar planned row is ignored; the
   calendar and observed behavior are unchanged. Run the budget/usage-meter/budget-level suites and push.
   Complete via the normal completion path.

Context: the maintainer separately raised `monk-fleet-ceiling` from 6 to 10 (`config/worker-leveling`) as a
stopgap until this reset. It will go back to 6 afterward. Don't touch it.
