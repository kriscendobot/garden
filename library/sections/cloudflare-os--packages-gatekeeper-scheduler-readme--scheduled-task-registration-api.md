---
title: Scheduled task registration API
source: packages/gatekeeper-scheduler/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [scheduled-agent-tasks, capability-mediated-integrations, cloudflare-workers-agent-hosting]
status: current
---

Scheduled Tasks is an ambient Gatekeeper that lets workspace code register persistent callbacks through three methods — `every()` for elapsed intervals, `calendarAt()` for wall-clock recurrences, and `runAt()` for one-time runs — where registration creates a disabled hook and a user must enable it before the schedule starts.

The user flow is: ask the agent to create a task or open the **Scheduled** app; confirm what it does, the workspace and resources it may use, its cadence, and its IANA timezone for wall-clock time; the agent registers a persistent callback and gets a schedule ID; the user enables the hook in the Workshop's Connections UI. Registration does not start the schedule — it only creates a disabled hook. The ambient binding exposes `ScheduleSession`, whose exact contract lives in `src/types.d.ts`.

The three registration methods match user intent: `every(everyMs, callback, options)` uses elapsed UTC time with a 60-second minimum interval; `calendarAt(rule, callback, options)` follows local wall-clock time, requires an explicit IANA timezone, and supports hourly, daily, and weekly rules; `runAt(when, callback, options)` runs once at an absolute epoch-millisecond timestamp or an explicit timezone-aware wall-clock time. Recurring `every()` and `calendarAt()` calls may stop after a finite bound — give `occurrences: { count: N }` or `occurrences: { until: … }`, never both, while `runAt()` accepts neither. The count bounds due slots, not successful runs: a slot consumes one count as soon as it becomes due and takes a `runId` even if admission or delivery then fails, retries reuse the same `runId` without consuming another count, and missed occurrences stay skipped and do not count. Registration rejects a cutoff that precedes the schedule's first occurrence, and the guidance is to always ask the user for the timezone of a wall-clock schedule rather than infer it from locale or silently choose UTC.

Source: [packages/gatekeeper-scheduler/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/gatekeeper-scheduler/README.md) at commit `ba4036b9`.
