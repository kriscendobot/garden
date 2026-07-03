# Skill: schedule

Race a schedule change onto the journal, so the scheduler service dispatches a
recurring job on its cadence. Use this when the user asks to add, change, or
remove a regularly scheduled task (most commonly a weekly task duplication).

## Purpose

Schedules are garden state on the bus. A dedicated `garden-scheduler` service is
the sole dispatcher: each tick it duplicates any due schedule's task onto the
board and stamps `last_dispatched` — atomically, so no host double-dispatches.

## Inputs / state

`journal/schedules/<name>.md` — one file per schedule. Two kinds:

Recurring (`cadence:`):
```
cadence: weekly            # weekly | daily | hourly | <N>s | <N>m | <N>h | <N>d
last_dispatched: <ISO>     # stamped by the scheduler; the dispatch note
job_basename_prefix: <p>   # dispatched job basename = <p>-<YYYYMMDD-HHMMSS>
preflight: <script>        # OPTIONAL deterministic gate (see below)
---
<the task body to duplicate each period>
```

The optional `preflight:` field names a script (resolved relative to
`scripts/jobs/`, passed the schedule name) the scheduler runs in plain code when
the cadence has elapsed, to decide whether there is any work BEFORE dispatching a
do-nothing agent. Exit `0` = work present → post the job and stamp
`last_dispatched`; exit `2` = no work → stamp `last_dispatched` only (advance the
clock, post nothing) and log `preflight gated: no work`; any other exit is treated
as work-present (fail open) so a broken gate never starves a schedule. A gate that
is **not found / not executable** (a deploy-lag or a typo'd `preflight:` path) also
fails open, but is DISTINGUISHED from a gate that runs and errors: the scheduler
counts consecutive not-found ticks in a `preflight_missing_streak` frontmatter line
and, past a small threshold (`GARDEN_PREFLIGHT_MISSING_THRESHOLD`, default 3),
escalates ONCE to the maintainer inbox so a permanently-absent gate gets fixed
instead of quietly re-firing an expensive dispatch every cadence. The streak resets
(and the escalation re-arms) as soon as the gate is found again. Wire one in
with `GARDEN_SCHEDULE_PREFLIGHT=<script> set-schedule.sh …`; it is preserved across
later cadence edits exactly like `last_dispatched`. Example:
`scholar-preflight.sh` gates `scholar-library-cycle` on a non-empty scholar inbox,
a claimable `scholar-*` job, or a fresh `role/scholar` broadcast.

One-time future (`once:`) — fires exactly once at a date, then the scheduler
DELETES the schedule file (CAS commit) so it never repeats:
```
once: <ISO>                # when to fire, e.g. 2026-07-01T09:00:00Z
job_basename_prefix: <p>   # dispatched job basename = <p> (no timestamp → idempotent retry)
---
<the task body to dispatch when due>
```

## Procedure

- Add/change recurring: `set-schedule.sh <name> <cadence> [prefix] [body-file]`
  (body else stdin). It CAS-races the file onto the journal, preserving any
  existing `last_dispatched`. Idempotent if unchanged.
- Add a one-time future job: `set-schedule-once.sh <name> <ISO> [prefix]
  [body-file]`. The scheduler dispatches it when due and removes the schedule in
  the same commit; the dispatched job basename is the prefix itself (no
  timestamp), so a retried dispatch is basename-idempotent.
- Remove: delete `schedules/<name>.md` and push (a normal CAS commit).
- The scheduler (`scheduler.sh`, `garden-scheduler.timer`) does the dispatching;
  you only post the schedule definition.

## Notes

The top-level agent races schedule changes to the journal with this skill rather
than editing a host-local crontab, so the schedule set is shared across hosts and
the single scheduler service honors it exactly once per period.
