---
ts: 2026-05-13T02:32:35Z
kind: dispatch
role: liaison
project: cosgov
to: "*"
refs:
  - entries/2026/05/13/023047Z-message-monitor-3fc6c7.md
---

# Dispatch: gardener lands cosgov per-event reaction rules

Dispatch root: `dispatches/gardener--land-cosgov-monitor-rules--20260513-023235--0af3e2/`. Routine maintenance dispatch in response to the cosgov monitor's proposal at `entries/2026/05/13/023047Z-message-monitor-3fc6c7.md`.

Task: edit `skills/monitor-cosgov/SKILL.md` to replace the placeholder `(unset)` reactions with the rules the monitor proposed. The proposal is concrete, justified, and consistent with the dispatch-prompt framing (cosgov is observation-only); the gardener lands it as written unless something is plainly wrong.

Out of scope: do not touch other per-project monitor skills (`monitor-endo`, `monitor-endo-but-for-bots`, `monitor-agoric-sdk`); each of those will likely produce its own proposal as its monitor subagent surfaces the same "all rules unset" condition, and each repo's posture differs. Wait for each per-repo proposal rather than guessing the others' rules now.

Report expected on return: the commit SHA on `main`, the diff summary (lines changed in the skill), and a one-line confirmation that the cosgov monitor's allowlist (kriskowal, netlify[bot], Copilot, kriscendobot) plus the ReleaseEvent exception are reflected.
