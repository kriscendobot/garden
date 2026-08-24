---
title: Scheduler cadence semantics and schedule lifecycle
source: packages/gatekeeper-scheduler/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [scheduled-agent-tasks, cloudflare-workers-agent-hosting]
status: current
---

Fixed intervals measure elapsed time and drift against local clocks across DST while calendar schedules retain their requested wall-clock cadence, and the schedule lifecycle keeps registration, enablement, and disablement separate: registration binds a disabled hook, enabling writes the driver row, and disabling deletes it without replaying missed work.

Cadence behavior: recurrences preserve the phase established at registration; missed occurrences are skipped rather than replayed or caught up; fixed intervals measure elapsed time and therefore shift relative to local clocks across DST; calendar schedules retain their local wall-clock cadence across DST; a nonexistent spring-forward time moves forward by the transition gap; an ambiguous fall-back time uses the earlier instant and fires once; and a date-less wall-clock one-shot resolves to the next future occurrence of that local time.

Lifecycle: registration only binds a disabled Workshop hook and writes no schedule row; enabling records the target workspace ID and optional gadget ID, then creates the account-driver row and arms its alarm; disabling removes the row and its stored capabilities. Re-enabling creates fresh active state, preserves the original recurrence phase, and does not replay missed work, while a repeated enable on an existing row preserves its current state and refreshes its activation details. Successful one-shots become **Finished**; past or rejected one-shots become expired; terminal rows stay visible and consume enabled-schedule quota until their hook is disabled. Creating a workspace from a blueprint copies no schedules or capabilities — the new workspace must register its callback and receive fresh enablement. Disconnecting the Scheduler account revokes its driver, deletes schedule state, and leaves a permanent tombstone so retained stale controllers cannot recreate the account.

Source: [packages/gatekeeper-scheduler/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/gatekeeper-scheduler/README.md) at commit `ba4036b9`.
