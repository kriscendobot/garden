---
ts: 2026-05-13T02:35:56Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/023053Z-message-monitor-b8bb4a.md
---

# Dispatch: gardener lands endo-but-for-bots monitor reaction rules

Dispatch root: `dispatches/gardener--land-endo-but-for-bots-monitor-rules--20260513-023556--9e2d63/`. One of three concurrent gardener dispatches landing per-project monitor rules from this turn's batch of proposals.

Task: edit `skills/monitor-endo-but-for-bots/SKILL.md` to land the rules from the monitor's proposal at `entries/2026/05/13/023053Z-message-monitor-b8bb4a.md`. The proposal frames the repo as the **active bot-evolution surface**, with routing distinctions for `kriskowal`-authored CHANGES_REQUESTED / APPROVED / COMMENTED reviews (routing to fixer / clear-backlog / fixer-with-authorization), authorization-grant detection on `IssueCommentEvent` (the `endojs/endo-but-for-bots#109` grant being the prototype), and a quiet default for routine maintainer pushes and bot-originated comments. Land it largely as written.

Out of scope: do not edit other per-project monitor skills (concurrent dispatches in flight). Do not modify `roles/monitor/AGENT.md`. Do not add an authorization-grant detection skill yet; the proposal mentions the pattern but landing a skill for it is a separate piece of work pending more examples.

Report on return: commit SHA on `main`, the diff summary, the chosen rule shape, and a self-improvement line.
