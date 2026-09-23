---
id: ticket-as-control-plane
aliases: ["ticket as control plane", "issue tracker as control plane", "issue tracker as orchestrator", "board as control plane", "every open task gets an agent", "tracker-driven orchestration", "deliverables not sessions"]
topics: [agent-fleet-orchestration]
status: current
---

# ticket-as-control-plane

The organizing idea behind fleet-level agent orchestration: make the **issue tracker (or job board) the control plane** for a fleet of coding agents. Rather than a human opening and supervising individual agent sessions, the system watches the task board and guarantees that **every open task has an agent running in its own workspace until it is done**, restarting agents that crash or stall and picking up new work as it appears. This reframes the unit of work away from sessions and pull requests (a means to an end) toward **deliverables** — issues, tasks, tickets, milestones — which decouples work from sessions (one ticket may yield several PRs across repos, or none), lets a ticket represent a large unit of work broken into a dependency DAG, and lets agents file their own follow-up tickets. OpenAI's Symphony realizes this over Linear; the garden realizes the same invariant over its git-backed job board, differing in that gardeners race to claim via push-CAS rather than a central orchestrator reserving each ticket.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [issue tracker as control plane](../sections/web--openai-symphony-codex-orchestration--issue-tracker-as-control-plane.md) | Any open task gets an agent workspace; Linear as state machine; dependency DAG; agents file their own follow-up issues. |
| [interactive-agent ceiling](../sections/web--openai-symphony-codex-orchestration--interactive-agent-ceiling.md) | Reframing the unit of work from sessions/PRs to tracker deliverables to escape the human-attention ceiling. |

## See also

- [[symphony-orchestrator]] — the canonical external implementation of this idea.
- [[objectives-over-state-machine]] — how tasks are framed once the tracker drives the work.
- [[workflow-md-policy]] — where the per-ticket agent policy lives.
