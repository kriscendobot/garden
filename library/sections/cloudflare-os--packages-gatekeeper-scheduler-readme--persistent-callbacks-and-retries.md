---
title: Persistent callbacks, retries, and terminal states
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

A scheduled callback is a persistent `ScheduledTaskHook.onSchedule()` made durable with `ctx.restore()`, delivered best-effort within a bounded eight-attempt retry window, and keyed by a `runId` the callback should treat as an idempotency key because delivery may occur more than once.

Each firing carries `scheduleId` (the stable registration ID), `runId` (stable across retries of one logical occurrence), `scheduledTime` (the planned Unix epoch time), `actualTime` (the current attempt time), and `timeZone` (the display timezone, `UTC` for elapsed intervals and numeric one-shots). Callback delivery is best-effort and may repeat, so callback code should use `runId` as its idempotency key. Authorization or callback failures retry up to eight total attempts with exponential delays beginning at one minute and capped at one hour; a schedule that exhausts them enters the **Needs attention** state. A Workshop admission check runs before every attempt: if the hook, gatekeeper, or account is no longer allowed, the occurrence is skipped without consuming a callback attempt — recurring schedules advance to their next future occurrence and a due one-shot expires.

The terminal states are checked against live state. A schedule that reaches its bound reports `completed`; one whose cutoff already passed by the time its hook is enabled reports `expired` because it never got a slot; and one whose callback exhausts its eight attempts reports `dead` and stops there whether or not the bound was reached — a `count: 10` schedule that dies on its third occurrence never reaches the fourth. Disabling a hook drops its driver state, so re-enabling the same schedule restarts the count, which means `count` is a bound per enablement rather than a lifetime guarantee. `list()` returns active and terminal schedules for enabled hooks in the current workspace only and does not expose schedules from other workspaces in the account.

Source: [packages/gatekeeper-scheduler/README.md](https://github.com/cloudflare/cloudflare-os/blob/ba4036b9366070a5d396b1bf76bc62b4fb50c9ab/packages/gatekeeper-scheduler/README.md) at commit `ba4036b9`.
