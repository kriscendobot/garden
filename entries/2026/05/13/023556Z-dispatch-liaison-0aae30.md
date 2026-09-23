---
ts: 2026-05-13T02:35:56Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
refs:
  - entries/2026/05/13/023600Z-message-monitor-926d77.md
---

# Dispatch: gardener lands agoric-sdk monitor reaction rules

Dispatch root: `dispatches/gardener--land-agoric-sdk-monitor-rules--20260513-023556--0aae30/`. One of three concurrent gardener dispatches landing per-project monitor rules from this turn's batch of proposals.

Task: edit `skills/monitor-agoric-sdk/SKILL.md` to land the rules from the monitor's proposal at `entries/2026/05/13/023600Z-message-monitor-926d77.md`. The proposal is a single rule (passive standing watch): journal one `tick` per `NEW` batch and do nothing further until the garden opens its first PR against `agoric/agoric-sdk` (or its forks). Land the banner-block patch the monitor sketched, leaving the per-class rows as `(passive standing watch; see banner)` so the structure stays in place for future refinement.

Out of scope: do not edit other per-project monitor skills (concurrent dispatches in flight). Do not modify `roles/monitor/AGENT.md`. Do not generalize the "passive watch" posture into the monitor role yet; agoric-sdk and cosgov both use a variant, but each has a different allowlist or trigger, so factoring out is premature.

Report on return: commit SHA on `main`, the diff summary, and a self-improvement line.
