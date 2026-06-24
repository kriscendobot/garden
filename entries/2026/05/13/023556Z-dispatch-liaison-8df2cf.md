---
ts: 2026-05-13T02:35:56Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/13/023003Z-message-monitor-bbcc25.md
---

# Dispatch: gardener lands endo monitor reaction rules

Dispatch root: `dispatches/gardener--land-endo-monitor-rules--20260513-023556--8df2cf/`. One of three concurrent gardener dispatches landing per-project monitor rules from this turn's batch of proposals.

Task: edit `skills/monitor-endo/SKILL.md` to land the rules from the endo monitor's proposal at `entries/2026/05/13/023003Z-message-monitor-bbcc25.md`. The proposal is enumerative (per-class routing with sub-cases for actor identity and bound-worktree state); the gardener should land it largely as written and may collapse the four reaction modes (silent / terse-tick / surface-bulletin / escalate-message) into a short prelude per the monitor's suggested skill-file shape. The endo posture is "active-participation by the garden but driven mostly via the per-PR roles": treat the bot's own pushes/comments as silent and surface maintainer-driven signals.

Out of scope: do not edit `monitor-endo-but-for-bots` or `monitor-agoric-sdk` skills (concurrent dispatches in flight for each). Do not modify `roles/monitor/AGENT.md` even though the proposal mentions adding a four-reaction-modes vocabulary to it; that generalization waits until at least three skills use the vocabulary (currently zero would after this dispatch, since cosgov collapsed differently).

Report on return: commit SHA on `main`, the diff summary, the chosen rule shape (collapsed vocab vs verbatim per-class), and a self-improvement line.
