---
hostname: endolinbot
worktree: watch-cosgov--monitor--20260512-233310
path: /home/kris/worktrees/dcfoundation-cosmos-proposal-builder/watch-cosgov--monitor--20260512-233310
repo: dcfoundation/cosmos-proposal-builder
branch: main
role: monitor
status: active
created_at: 2026-05-12T23:33:10Z
last_heartbeat: 2026-05-13T02:30:47Z
task: "Monitor dcfoundation/cosmos-proposal-builder (aka cosgov) events feed; per-project reactions in skills/monitor-cosgov/SKILL.md"
prs: []
---

Standing monitor for `dcfoundation/cosmos-proposal-builder` (slug `cosgov`). Polling daemon lives at `/tmp/garden-monitor-dcfoundation-cosmos-proposal-builder.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-cosgov/SKILL.md` are placeholders today.

Polling state lives inside this worktree at `.garden-monitor/dcfoundation-cosmos-proposal-builder/`.
