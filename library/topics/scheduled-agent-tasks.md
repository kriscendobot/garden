Persistent scheduled callbacks for agent workspaces: registering elapsed-interval, wall-clock, and one-time tasks, their occurrence bounds and retry semantics, DST-aware cadence, enable/disable lifecycle, and the account-scoped driver that runs them.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [Scheduled task registration API](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--scheduled-task-registration-api.md) | scheduled-agent-tasks, capability-mediated-integrations, cloudflare-workers-agent-hosting | Three registration methods and occurrence bounds; registration creates a disabled hook. |
| [Persistent callbacks, retries, and terminal states](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--persistent-callbacks-and-retries.md) | scheduled-agent-tasks, capability-mediated-integrations, cloudflare-workers-agent-hosting | Durable callbacks keyed by runId, eight-attempt retries, and completed/expired/dead states. |
| [Scheduler cadence semantics and schedule lifecycle](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--cadence-and-lifecycle.md) | scheduled-agent-tasks, cloudflare-workers-agent-hosting | DST-aware cadence and a lifecycle separating registration, enablement, and disablement. |
| [Scheduler architecture, driver, and fixed limits](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--architecture-and-limits.md) | scheduled-agent-tasks, cloudflare-workers-agent-hosting, capability-mediated-integrations | One SQLite ScheduleDriver DO and alarm per account, a read-only app, and fixed policy limits. |
| [What the snapshot changes in practice (resident agents and an actor framework)](../sections/web--haruni-kaozkit-xs-agents--what-the-snapshot-changes-in-practice.md) | xs-agent-runtimes, persistence, scheduled-agent-tasks | A resident agent (`kaoz concierge.js --resident --daemon --state brain.bin`) survives Ctrl-C and restart from its heap-snapshot file, including a `host.schedule` reminder that fires in a process that did not exist when it was set. |

## See also

- [capability-mediated-integrations](capability-mediated-integrations.md)
- [cloudflare-workers-agent-hosting](cloudflare-workers-agent-hosting.md)
