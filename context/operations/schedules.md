# Recurring and one-shot schedules

How to make the garden run a job on a cadence (commonly a weekly task
duplication) or exactly once at a future time. Schedules live in the journal so
the set is **shared across hosts**, and the sole `garden-scheduler` service (a
leader-only singleton) dispatches them on cadence. This page is the operator's
entry point; the mechanics — the CAS race onto the journal, the record shape —
are owned by `skills/schedule/SKILL.md`, and this page routes to it rather than
duplicating it. If your question is "run X weekly" or "fire Y once at a time,"
you are here.

## The commands

```sh
scripts/jobs/set-schedule.sh <name> <cadence> [prefix] [body-file]   # recurring
scripts/jobs/set-schedule-once.sh <name> <ISO-time>                  # fires once, then self-deletes
```

`set-schedule.sh` CAS-races the schedule onto the journal; the `garden-scheduler`
service dispatches it on the given cadence (e.g. `weekly`). `set-schedule-once.sh`
fires exactly once at the ISO time and then deletes itself. **Prefer these over a
host-local crontab** so the schedule set is shared across hosts rather than
stranded on one machine — the scheduler is a leader-only singleton and dispatches
the shared set for the whole fleet.

## Pausing and restoring

The scheduler enumerates journal `schedules/` only. A paused schedule is the same
record moved to sibling `paused-schedules/`; there is no `paused: true` field and
no separate scheduler switch. Restore it by reversing the move:

```sh
git -C "$DIR" mv schedules/<name>.md paused-schedules/<name>.md  # pause
git -C "$DIR" mv paused-schedules/<name>.md schedules/<name>.md  # restore
```

Perform the move in a freshly synced isolated producer clone (`$DIR`), commit the
one rename, and CAS-push it to `journal2`, retrying from the new tip after a lost
push race. Do **not** make this commit in the live `journal/` worktree: it may be
stale or contain another producer's work. The move preserves cadence,
`last_dispatched`, job body, and timeout exactly. Restoring makes the record
eligible on the next scheduler tick; if its cadence is already due, it may
dispatch immediately. Pausing does not recall a copy already posted to `todo/` or
claimed into `doin/`; control that job separately.

## Where the detail lives

The record shape, the cadence vocabulary, and the CAS-race procedure are in
`skills/schedule/SKILL.md` — read it when adding or changing a schedule. Related:
one-off and parked work is the plan queue (`post-plan.sh`), and multi-part work
gets an **orchestration** rather than a schedule (`skills/orchestration/SKILL.md`);
this page covers only time-triggered recurrence.
