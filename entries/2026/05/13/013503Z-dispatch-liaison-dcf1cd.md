---
ts: 2026-05-13T01:35:03Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/012651Z-message-steward-480000.md
---

# Dispatch: create the gardener role and the monitor-arming skill

Dispatch root: `dispatches/liaison--create-gardener-role-and-monitor-arming-skill--20260513-013453--dcf1cd/`. One of three concurrent dispatches firing this turn. The maintainer confirmed `gardener` as the new role's name.

Task: land two files on `main`:

1. `roles/gardener/AGENT.md`: per the steward's sketch in `entries/2026/05/13/012651Z-message-steward-480000.md` § Part 2 § Proposed shape. Purpose, when-dispatched triggers (a journal lesson warrants new role/skill; a self-improvement note recurs across cycles; the active library has drifted; a scheduled audit interval has elapsed), authority bounds (identical to liaison's role-edit authority, no project-side decisions, no upstream push, only writes to `roles/`, `skills/`, and journal entries documenting the work), skills list, done.

2. `skills/monitor-arming/SKILL.md`: capture the Monitor-over-daemon discipline from `entries/2026/05/13/012651Z-message-steward-480000.md` § Part 1 § "What discipline would have caught it":
   - Pre-arm probe (deliberate event before declaring the Monitor armed).
   - Out-of-band freshness check (compare daemon's last-emitted timestamp against current time plus cadence plus slack; if silent during apparent activity, the daemon is broken).
   - Optional active heartbeat (daemon emits periodic heartbeat lines; Monitor wakes on missing-heartbeat).

Both files carry standard frontmatter (created/updated 2026-05-13, author liaison). The skill cites the steward's message entry as its origin; the role file cites the skill in its Skills section.

Update `CLAUDE.md` § Current inventory: add `gardener` to Roles, `monitor-arming` to Skills.
Update `roles/liaison/AGENT.md`: add a one-line norm naming the gardener as the liaison's deputy for routine meta-evolution dispatches, and add `gardener` to the *Translate user prompts to a role* matching list at the top of the active library.

Do **not** dispatch a sub-subagent. Do not edit other roles' files beyond the liaison note above.

Report expected on return: commit SHAs on `main` (one or two, your call), one-line description of each authored file.
