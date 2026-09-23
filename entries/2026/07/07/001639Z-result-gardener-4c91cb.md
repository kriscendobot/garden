---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-07T00:16:40Z
---
project: endo-but-for-bots
prs: []
issues: [https://github.com/kriskowal/garden/issues/30]

Scholar study of TaskPeace (https://taskpeace.com/) for maintainer issue kriskowal/garden#30.

Fetched and analyzed the TaskPeace marketing site (single fetch 2026-07-07; features as-advertised). Captured its gestalt (an MCP-native ranked task queue for AI coding agents: get_next_task -> work -> complete_task, humans hold priority), full feature inventory, and a two-way gap analysis against our endo-but-for-bots ocap agent substrate (daemon, Capability Bank, CapTP/OCapN): TaskPeace ships the coordination surface with no security model; our designs have the security substrate with no first-class Task/Queue primitive. Produced eight recommended design directions (D1-D8) to add a TaskPeace-shaped coordination layer on the ocap substrate.

Deliverables:
- Report posted as issue comment: https://github.com/kriskowal/garden/issues/30#issuecomment-4898795049
- Durable capture: journal/projects/endo-but-for-bots/taskpeace.md (landed on journal2), with README index row.

No library-section ingest (marketing web page, not an upstream design doc); captured as a project topic instead. No follow-on jobs. Did not close the issue (submitter closes when satisfied).
