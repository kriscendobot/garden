---
ts: 2026-05-13T01:39:47Z
kind: result
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/013320Z-dispatch-liaison-e88a31.md
  - entries/2026/05/13/012651Z-message-steward-480000.md
---

# Gardener role and monitor-arming skill landed

Per the steward's proposal in `012651Z-message-steward-480000.md` and the maintainer's confirmation of `gardener` as the role's name, the subagent (dispatched as a liaison-proxy in `liaison--create-gardener-role-and-monitor-arming-skill--20260513-013453--dcf1cd`) landed the two new files and the matching inventory + liaison updates on `main`.

**New files:**

- `roles/gardener/AGENT.md`: liaison's deputy for meta-evolution of roles and skills. Same role-edit authority the liaison has within its dispatch; cannot be dispatched by the steward (meta-evolution is outside the steward's authority bounds).
- `skills/monitor-arming/SKILL.md`: discipline for arming a Monitor over a daemon not controlled end-to-end. Three patterns (pre-arm probe, out-of-band freshness check, active heartbeat); freshness check is the recommended floor. Carries the steward's `monitor-poll.sh` Push-id incident as the canonical Note from the field.

**Commits on `main`:**

- `0faa198` gardener role and monitor-arming skill: meta-evolution deputy + daemon-watch discipline (per steward msg 012651Z-message-steward-480000)
- `ae694de` inventory + liaison: enumerate the gardener role and the monitor-arming skill

Both pushed to `origin/main` after a clean rebase across `0da84da` (the steward's concurrent monitor-poll fix landed during this dispatch and replayed without conflict).

**Inventory deltas:**

- `CLAUDE.md` § Current inventory: `gardener` appended to Roles; `monitor-arming` appended to Skills.
- `roles/liaison/AGENT.md`: new operating norm `**Gardener for routine meta-evolution.**` between *Meta work goes on `main`* and *Worktree manager*. *Translate user prompts to a role* step 1 now enumerates the active set explicitly (including `gardener`) and routes role/skill design or library-audit requests to the gardener rather than authoring inline. Frontmatter `updated:` bumped to 2026-05-13.

The steward's role file was deliberately not touched (the steward cannot dispatch the gardener; that is the contract). The other per-PR roles' AGENT.md files were also not touched per dispatch instructions (liaison-only).

Self-improvement: `roles/gardener/AGENT.md`, `skills/monitor-arming/SKILL.md`; the steward's "meta-evolution lessons stall in liaison's reactive queue" observation now has a dedicated role to absorb it, and the Monitor-over-daemon failure mode is captured in a skill the gardener's own role file references for future monitor-arming agents.
