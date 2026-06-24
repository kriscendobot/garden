---
ts: 2026-05-13T05:38:22Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener builds the timekeeper role, scheduling skill, and the first scheduled event

Dispatch root: `dispatches/gardener--timekeeper-and-scheduling--20260513-053822--02e8c4/`.

The maintainer asked for a `timekeeper` role plus a scheduling skill plus a concrete first-scheduled-event (daily midnight Pacific summary).

## Tasks

### A. `roles/timekeeper/AGENT.md`

Autonomous like the steward and the liaison; the timekeeper runs in the bot sandbox on a tunable cadence, watching for scheduled events whose trigger timestamp has elapsed and dispatching them. Posture:

- Manages a per-event schedule indexed by trigger timestamp. The schedule is journal-side state (see task B for the data layout).
- Each cycle: read the next scheduled event from the schedule; if its trigger time has elapsed, dispatch it (per the event's own dispatch shape) and either remove the event from the schedule (one-shot events) or schedule the next occurrence in the series (recurring events).
- Precise and drift-free: every timestamp arithmetic operation uses a reliable script, not intuition. The scheduling skill provides the helpers; the timekeeper consumes them.
- Authority bounds: identical shape to the steward (cannot edit roles/skills, cannot push upstream, cannot originate authorizations). May write `dispatch`, `tick`, `result` journal entries and may edit the schedule's journal-side state.
- Cadence: idle by default, active when the next scheduled event is within the active-mode window. Use `skills/autonomous-loop-pacing/SKILL.md` for delaySeconds picks.

### B. `skills/scheduling/SKILL.md`

The skill that any role uses to schedule a future event. Content:

- Where the schedule lives: `journal/schedule/<owner>-<repo-or-garden>/<UTC-trigger-timestamp>--<short-id>.md` (or a flat layout if the gardener prefers; pick what is simplest and document). Each file is one event with frontmatter naming the trigger time, the timezone of intent (e.g., "Pacific midnight"), the dispatch shape (role + purpose-slug + arguments), and the recurrence rule (one-shot or a cron-style spec).
- How to construct a timestamp: use the helper script (task D below) `skills/scheduling/next-trigger.sh` (or equivalent name) to compute UTC trigger timestamps from local-time intents. Do NOT hand-craft ISO-8601 strings; timezone arithmetic is the canonical source of drift bugs.
- How to mark an event fired (or how the timekeeper does so): atomic rename to `journal/schedule/_fired/<original-name>` with the fired timestamp prepended, or delete after the timekeeper dispatches and the dispatched role returns. Gardener picks the convention.
- How to schedule the next occurrence of a recurring event: the event's recurrence frontmatter declares "every 24h" or "Pacific midnight"; the next trigger is computed by the script, not by adding 86400 to the prior one (which drifts across DST). Recurrence is computed forward from the *intended* schedule, not from the *actual* fired time.

### C. `skills/scheduling/next-trigger.sh` (or similarly-named helper script)

A small script (Python or bash) that computes the next UTC trigger timestamp for a recurrence rule. Per the maintainer's note: "use a reliable script rather than intuition for constructing timestamps." Inputs: recurrence rule (e.g. `daily at 00:00 America/Los_Angeles`), reference time (default: now UTC). Output: ISO-8601 UTC trigger timestamp. Handles DST correctly (Python's `zoneinfo` is the cleanest).

The script lives in the scheduling skill's directory per the now-established convention.

### D. First scheduled event: daily midnight Pacific progress summary

Seed `journal/schedule/garden/<next-midnight-pacific-UTC>--<short-id>.md` declaring:

- Trigger: the next 00:00 America/Los_Angeles instant, expressed as UTC.
- Timezone of intent: `America/Los_Angeles`, 00:00.
- Recurrence: daily.
- Dispatch shape: a `journalist` (or a new sub-role; gardener decides — the journalist is the natural choice since periodicals are journalism) dispatch with purpose `daily-progress-summary` and an instruction to: read the journal for entries in the prior 24h, summarize progress, and write the result as a periodical entry under `journal/periodicals/<date>.md` (or `journal/periodicals/<year>/<month>/<day>.md` per the context-library rules; gardener picks).
- The summary covers all activity (every project), not just one.

Create the destination directory's README: `journal/periodicals/README.md` with the abstract + index conventions per `skills/context-library/SKILL.md`.

### E. Inventory and interlock updates

- `CLAUDE.md` § Current inventory: add `timekeeper` to Roles and `scheduling` to Skills.
- `roles/liaison/AGENT.md` § Translate user prompts to a role: extend the active-set enumeration with `timekeeper`.
- The journalist's role file: note that it may receive `daily-progress-summary` dispatches from the timekeeper and how to handle them (read the last 24h of entries, write the periodical).

### F. Bootstrap

- Add an `Awaits maintainer decision` bulletin row reminding the maintainer to kick off the timekeeper once it is ready (same shape as the scholar's kick-off bulletin row from the prior dispatch).
- The timekeeper does not auto-start; the maintainer chooses the cadence and signals "start."

## Out of scope

- Do not run the timekeeper for its first cycle.
- Do not run the journalist's first daily-summary dispatch.
- Do not modify any non-named role or skill file beyond the inventory and interlock edits in task E.
- Do not touch the monitor-restriction safety work (concurrent gardener dispatch handles that).

## Style and discipline

Em-dash sweep; frontmatter; relative paths; context-library rules for the new schedule and periodicals trees. Do not invoke `Agent`. Use the journal-sync skill's retry-on-rejection (concurrent gardener dispatch and possibly the steward are pushing during this engagement). Sync your journal worktree **before** editing tracked files (per `skills/journal-sync/SKILL.md` § Notes from the field).

## Commits + push

Suggested split on `main`:

- A: `timekeeper role: autonomous scheduled-event dispatcher`.
- B: `scheduling skill: how roles register future work and how the timekeeper consumes the schedule`.
- C: `scheduling: next-trigger helper script` (lives in skill dir).
- E: `inventory and interlocks: name the timekeeper and scheduling`.

Suggested commits on `journal`:

- D: `schedule: first event (daily midnight Pacific progress summary) plus periodicals/ tree`.
- F: `bulletin: kick-off reminder for the timekeeper`.
- Result.

## Return

≤ 500 words: files written grouped by task A–F, commit SHAs (main + journal), the recurrence-rule shape you chose, the chosen schedule-file layout, any follow-ups for liaison.
