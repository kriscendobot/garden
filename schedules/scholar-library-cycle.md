cadence: hourly
last_dispatched: 2026-07-06T02:20:10Z
job_basename_prefix: scholar-library-cycle
preflight: scholar-preflight.sh
---

# Hourly scholar library cycle

A periodical scholar cycle that fires every UTC hour at :00. Dispatched into a
[scholar](../../roles/scholar/AGENT.md) subagent in a fresh dispatch root. The
scholar follows its standard per-cycle procedure: sync the journal, drain the
scholar topic/inbox, process up to its section budget (about 3 to 5 source
documents or 25 section writes), update `library/` indexes, journal a `result`
entry, exit.

## Why hourly

The scholar's cadence wants 1800-3600s in idle mode and ≤1800s in active mode.
The closest supported recurrence is hourly. When the inbox is empty the cycle
drains quickly and exits; when there is backlog the cycle processes its budget
and defers the rest to the next fire.

If the inbox accumulates faster than hourly can drain, register a second
half-hour-offset schedule.

## Indefinite-loop intent

The schedule has no end date. It fires every hour until the maintainer removes
it.

---
Translated from v1 `schedule/garden/20260514T010000Z--72f1f4.md`
(recurrence `hourly-at-00-UTC`, dispatch `scholar` / `library-cycle`).
The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
specs keyed by cadence, not pre-computed per-fire event files. The v1 original
is retained on `journal-v1` and `origin/journal`.
