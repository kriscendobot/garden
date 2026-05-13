---
hostname: endolinbot
worktree: watch-cosgov--monitor--20260512-233310
path: /home/kris/worktrees/dcfoundation-cosmos-proposal-builder/watch-cosgov--monitor--20260512-233310
repo: dcfoundation/cosmos-proposal-builder
branch: main
role: monitor
status: collected
created_at: 2026-05-12T23:33:10Z
last_heartbeat: 2026-05-13T02:30:47Z
collected_at: 2026-05-13T05:38:22Z
task: "Monitor dcfoundation/cosmos-proposal-builder (aka cosgov) events feed; per-project reactions in skills/monitor-cosgov/SKILL.md"
prs: []
---

Standing monitor for `dcfoundation/cosmos-proposal-builder` (slug `cosgov`). Polling daemon lives at `/tmp/garden-monitor-dcfoundation-cosmos-proposal-builder.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-cosgov/SKILL.md` are placeholders today.

Polling state lives inside this worktree at `.garden-monitor/dcfoundation-cosmos-proposal-builder/`.

**Collected 2026-05-13** per the monitoring safety constraint in `CLAUDE.md` § Monitoring safety constraint and `roles/COMMON.md` § Monitoring safety constraint (precipitating dispatch: [`entries/2026/05/13/053822Z-dispatch-liaison-44e029.md`](../../entries/2026/05/13/053822Z-dispatch-liaison-44e029.md)). The daemon was killed and the standing-monitor row removed from `roles/steward/AGENT.md`. The filesystem worktree at `path` above is deliberately left on disk so polling state under `.garden-monitor/` survives in case the constraint reverses; the steward no longer checks liveness for this entry. To re-arm: obtain maintainer authorization (journal `message` entry), restore the row in `roles/steward/AGENT.md` § Standing monitors and the active mapping in `roles/monitor/AGENT.md`, remove the DORMANT banner from `skills/monitor-cosgov/SKILL.md`, flip this entry's `status` back to `active`, and respawn the daemon.
