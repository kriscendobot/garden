---
hostname: endolinbot
worktree: watch-agoric-sdk--monitor--20260512-233309
path: /home/kris/worktrees/agoric-agoric-sdk/watch-agoric-sdk--monitor--20260512-233309
repo: agoric/agoric-sdk
branch: master
role: monitor
status: active
created_at: 2026-05-12T23:33:09Z
last_heartbeat: 2026-05-12T23:33:29Z
task: "Monitor agoric/agoric-sdk events feed; per-project reactions in skills/monitor-agoric-sdk/SKILL.md"
prs: []
---

Standing monitor for `agoric/agoric-sdk`. Polling daemon lives at `/tmp/garden-monitor-agoric-agoric-sdk.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-agoric-sdk/SKILL.md` are placeholders today.

Polling state lives inside this worktree at `.garden-monitor/agoric-agoric-sdk/`.
