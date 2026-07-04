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
cadence: weekly            # interval: weekly | daily | hourly | <N>s | <N>m | <N>h | <N>d
                           # anchored: daily-at-HH:MM-<TZ>  (DST-aware wall-clock, see below)
last_dispatched: <ISO>     # stamped by the scheduler; the dispatch note
job_basename_prefix: <p>   # dispatched job basename = <p>-<YYYYMMDD-HHMMSS>
preflight: <script>        # OPTIONAL deterministic gate (see below)
---
<the task body to duplicate each period>
```

Two cadence families. An **interval** cadence (`weekly`/`daily`/`hourly`/`<N>{s,m,h,d}`)
fires `cad_s` seconds after the previous dispatch and stamps `last_dispatched` to
the fire time, so a late tick drags every future fire forward — right for "every N
hours", wrong for "at midnight local". An **anchored** cadence,
`daily-at-HH:MM-<TZ>` (e.g. `daily-at-00:00-America/Los_Angeles`), pins the fire to
a wall-clock `HH:MM` in a named IANA timezone: due-ness is decided against the most
recent anchor instant at-or-before now, and `last_dispatched` is stamped to that
**anchor** (not the actual fire time). So the daily wall-clock time never drifts
even when a tick fires hours late — the next fire is always computed forward from
the *intended* schedule — and DST transitions are handled by the zoneinfo database
(a 23h/25h local day is spanned correctly). For an anchored daily cadence the
scheduler also **prepends a computed context block** to the dispatched job body
naming the `prior 24 hours` window (`window_start`/`window_end`, UTC) and the
`pacific_date` + `journal/periodicals/<YYYY>/<MM>/<DD>.md` output path the fire
covers, so the claiming agent need not re-derive the window from its own (possibly
late) claim time. The `daily-progress-summary` periodical uses this cadence.

The optional `preflight:` field names a script (resolved relative to
`scripts/jobs/`, passed the schedule name) the scheduler runs in plain code when
the cadence has elapsed, to decide whether there is any work BEFORE dispatching a
do-nothing agent. Exit `0` = work present → post the job and stamp
`last_dispatched`; exit `2` = no work → stamp `last_dispatched` only (advance the
clock, post nothing) and log `preflight gated: no work`; any other exit is treated
as work-present (fail open) so a broken gate never starves a schedule. A gate that
is **not found / not executable** (a deploy-lag or a typo'd `preflight:` path) also
fails open, but is DISTINGUISHED from a gate that runs and errors: on the FIRST tick
of the breakage the scheduler escalates ONCE to the maintainer inbox (via
`alert_maintainer`, keyed/deduped on the schedule name — the journal-worktree
keeper's paging-key discipline), so a permanently-absent gate gets surfaced and
fixed instead of quietly re-firing an expensive dispatch every cadence. The
escalation is also deduped by a per-`(schedule, resolved-path)` marker under
`$GARDEN_STATE`, and the same marker keeps the not-found **WARN** to ONCE per
breakage rather than every due tick. When the SAME script is present on
`origin/$GARDEN_MAIN_BRANCH` but absent from this deployed root, the scheduler
diagnoses **deploy-lag** — the escalation names the pending deploy as the cause and
it also drops a distinct one-shot note in the deploy state dir (beside the
`upgrade-ready` marker the liaison's deploy Monitor watches). The WARN, the
escalation, and the deploy-lag diagnosis all reset (and re-arm) as soon as the gate
is found again. Wire one in
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
