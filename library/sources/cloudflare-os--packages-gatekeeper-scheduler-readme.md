---
source: packages/gatekeeper-scheduler/README.md
source_repo: cloudflare/cloudflare-os
source_commit: ba4036b9366070a5d396b1bf76bc62b4fb50c9ab
source_date: 2026-08-14
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
section_count: 4
status: current
---

The Scheduled Tasks Gatekeeper README covers an ambient connector for persistent scheduled callbacks: the three registration methods and their occurrence bounds, the durable callback contract with `runId` idempotency and eight-attempt retries, cadence and lifecycle semantics across DST and enable/disable, and the single-driver architecture, read-only management app, and fixed policy limits.

| Section | Topics | Status |
|---|---|---|
| [Scheduled task registration API](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--scheduled-task-registration-api.md) | scheduled-agent-tasks, capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
| [Persistent callbacks, retries, and terminal states](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--persistent-callbacks-and-retries.md) | scheduled-agent-tasks, capability-mediated-integrations, cloudflare-workers-agent-hosting | current |
| [Scheduler cadence semantics and schedule lifecycle](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--cadence-and-lifecycle.md) | scheduled-agent-tasks, cloudflare-workers-agent-hosting | current |
| [Scheduler architecture, driver, and fixed limits](../sections/cloudflare-os--packages-gatekeeper-scheduler-readme--architecture-and-limits.md) | scheduled-agent-tasks, cloudflare-workers-agent-hosting, capability-mediated-integrations | current |
