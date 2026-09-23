---
id: scheduled-tasks-gatekeeper
aliases: [Scheduled Tasks, Scheduler gatekeeper, gatekeeper-scheduler, ScheduleSession, ScheduleDriver, calendarAt, runAt, persistent callback, scheduled task]
topics: [scheduled-agent-tasks, capability-mediated-integrations]
---

# Scheduled Tasks Gatekeeper

The Cloudflare OS ambient Gatekeeper that lets workspace code register persistent callbacks for elapsed intervals (`every`), wall-clock recurrences (`calendarAt`), and one-time runs (`runAt`). Registration creates a disabled hook that a user must enable, callbacks are durable (`ctx.restore()`) and delivered best-effort with `runId`-keyed idempotency across an eight-attempt retry window, and each account owns one SQLite-backed `ScheduleDriver` Durable Object and alarm that is both the coordination point and a shared failure domain.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Scheduled task registration API](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--scheduled-task-registration-api.md) | Three registration methods and occurrence bounds; registration creates a disabled hook. |
| [Persistent callbacks, retries, and terminal states](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--persistent-callbacks-and-retries.md) | Durable callbacks keyed by runId, eight-attempt retries, and completed/expired/dead states. |
| [Scheduler cadence semantics and schedule lifecycle](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--cadence-and-lifecycle.md) | DST-aware cadence and a lifecycle separating registration, enablement, and disablement. |
| [Scheduler architecture, driver, and fixed limits](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--architecture-and-limits.md) | One SQLite ScheduleDriver DO and alarm per account, a read-only app, and fixed policy limits. |

## See also

- [[cloudflare-os-gatekeeper]]
