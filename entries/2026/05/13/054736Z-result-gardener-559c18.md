---
ts: 2026-05-13T05:47:36Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/13/053822Z-dispatch-liaison-02e8c4.md
---

# Result: timekeeper role, scheduling skill, first scheduled event

Built the `timekeeper` autonomous role, the `scheduling` skill (plus its `next-trigger.sh` helper), the seed daily-midnight-Pacific event, the `journal/periodicals/` destination tree, the inventory + interlock updates, and the kick-off bulletin row. Per the dispatch at [`053822Z-dispatch-liaison-02e8c4.md`](053822Z-dispatch-liaison-02e8c4.md).

## Files written

### Task A: timekeeper role

- `garden/roles/timekeeper/AGENT.md`: autonomous scheduled-event dispatcher. Posture and authority bounds mirror the steward and scholar; cadence is event-driven (next-trigger time drives wakeup, idle-when-empty fallback). Per-cycle procedure: sync, survey schedule, dispatch elapsed events with recurrence rollover (write next before archiving current), aggregate, self-improve, schedule, exit. The single `ScheduleWakeup` call site is step 6.

### Task B: scheduling skill

- `garden/skills/scheduling/SKILL.md`: canonical for the schedule layout, event-file frontmatter shape, recurrence-rule shape, and the firing flow.
  - Layout: `journal/schedule/<owner-or-garden>/<UTC-compact-ts>--<short-id>.md` for pending; `journal/schedule/_fired/<original-rel-path>` for archive.
  - Recurrence rule shape: kebab strings parsed by the helper script. Supported: `one-shot`, `daily-at-<HH:MM>-<tz>`, `weekly-on-<weekday>-at-<HH:MM>-<tz>`, `hourly-at-<MM>-<tz>`.
  - Firing flow: prepare worktree triple, journal dispatch, invoke `Agent`, journal result, teardown, then *rollover* (write next event file before archiving current). Order matters; an interrupted cycle leaves the schedule consistent.

### Task C: helper script

- `garden/skills/scheduling/next-trigger.sh`: Python `zoneinfo`-backed. Inputs are the rule plus optional reference time (UTC ISO-8601); output is two lines on stdout (ISO-8601 + compact form). Tested against the daily Pacific midnight rule in DST (07:00 UTC) and outside DST (08:00 UTC), the weekly Monday UTC rule, hourly UTC, and the `one-shot` no-next-trigger case.

### Task D: first scheduled event + periodicals tree

- `journal/schedule/garden/20260513T070000Z--5a93f9.md`: seed event. Trigger 2026-05-13T07:00:00Z (00:00 PDT). Recurrence `daily-at-00:00-America/Los_Angeles`. Dispatch shape: `journalist` / `daily-progress-summary` with `window: "prior 24 hours"`, `output: "journal/periodicals/<YYYY>/<MM>/<DD>.md"`, `scope: "all projects"`.
- `journal/schedule/README.md`: index per `skills/context-library/SKILL.md`. One pending bullet for the seed event.
- `journal/periodicals/README.md`: index for the periodical tree. Layout `<YYYY>/<MM>/<DD>.md` per kind; entry shape for the daily progress summary (abstract first, by-project sections, garden-meta tail).

### Task E: inventory + interlocks

- `garden/CLAUDE.md` § Current inventory: added `timekeeper` to Roles, `scheduling` to Skills.
- `garden/roles/liaison/AGENT.md` § Translate user prompts to a role: extended active-set enumeration with `timekeeper` (also `librarian`, `scholar` which were missing).
- `garden/roles/journalist/AGENT.md`: new *Daily progress summaries* section covering input (event-file frontmatter + window), output (periodical file shape and path), scope (every project), bulletin-untouched discipline, and Done criteria for periodical dispatches. Posture paragraph updated to mention the timekeeper-driven dispatch shape.

### Task F: bootstrap bulletin

- `journal/README.md` § Awaits maintainer decision: new *Timekeeper kick-off* row referencing the role, the scheduling skill, the seed event, and the periodicals tree. Pattern mirrors the scholar's kick-off row.

## Commit SHAs

Main (`origin/main`, pushed): `b431e3c` (A timekeeper role), `a4c7a21` (B scheduling skill), `8a53f88` (C next-trigger.sh), `e0115b4` (E inventory + interlocks).

Journal (`origin/journal`, pushed): `642b09b` (D schedule + periodicals tree), `3b61a17` (F bulletin row), this result entry.

## Choices

- **Recurrence-rule shape**: kebab string parsed by the helper script (e.g. `daily-at-00:00-America/Los_Angeles`). The structured-frontmatter alternative (`frequency:`, `at:`, `timezone:`) was considered but rejected: the kebab form survives the round trip through filenames, conversation, and journal entries as a single atom, and the script parses once. Documented in `skills/scheduling/SKILL.md` § Notes from the field.
- **Schedule layout**: tree shape per the context-library rules. `journal/schedule/<owner-or-garden>/<UTC-trigger>--<short-id>.md` for pending; `journal/schedule/_fired/<original-rel-path>` for the archive. Flat layout was rejected because growth across upstream owners will fan out, and a per-owner directory keeps each branch grep-able.
- **Periodicals layout**: `journal/periodicals/<YYYY>/<MM>/<DD>.md` per the daily summary kind, with sibling subtrees for future kinds. Filename is the *local Pacific date* of the window, not the UTC date of the trigger; the journalist's dispatch arguments name the window unambiguously.
- **Helper script language**: Python 3 with `zoneinfo`. Bash arithmetic for DST-aware timestamp math was rejected; the dispatch prompt explicitly warned of bash's fragility on timezones.

## Follow-ups for liaison

- The maintainer needs to signal "start" for the timekeeper's first cycle (the bulletin row encodes the gate). Until then, no scheduled event fires.
- The seed event will fire in ~2 hours at 07:00 UTC if the timekeeper is kicked off before then. If kicked off later, the first cycle will fire the elapsed seed event immediately (per the timekeeper's *elapsed events* rule) and write the next day's event before archiving.
- The journalist's new *Daily progress summaries* section depends on the journalist actually being able to enumerate `project:`-tagged entries by slug; the existing journalist already does this for the bulletin's review lists, so the muscle is present. The first periodical run will exercise it.
- Consider whether the timekeeper's standing-monitor-like lifecycle (one autonomous loop per garden instance, restarted by the steward if it dies) needs explicit liveness checking in `roles/steward/AGENT.md` § Standing monitors. Today the steward owns the daemons; the timekeeper is a peer loop, not a daemon, so this may not apply. Flag if you want a separate gardener pass on standing-loop liveness across the steward + scholar + timekeeper trio.

Self-improvement: the recurrence-rule decision (flat kebab vs structured frontmatter) is exactly the shape of decision that benefits from being *recorded in the skill's Notes from the field* at authoring time, before the alternative shape leaks into practice. Did so on this dispatch; this row codifies "record the path-not-taken at authoring" as the gardener's standing practice.
