---
hostname: endolinbot
worktree: watch-agoric-sdk--monitor--20260512-233309
path: /home/kris/worktrees/agoric-agoric-sdk/watch-agoric-sdk--monitor--20260512-233309
repo: agoric/agoric-sdk
branch: master
role: monitor
status: collected
created_at: 2026-05-12T23:33:09Z
last_heartbeat: 2026-05-13T02:32:29Z
collected_at: 2026-05-13T05:38:22Z
task: "Monitor agoric/agoric-sdk events feed; per-project reactions in skills/monitor-agoric-sdk/SKILL.md"
prs: []
---

Standing monitor for `agoric/agoric-sdk`. Polling daemon lives at `/tmp/garden-monitor-agoric-agoric-sdk.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-agoric-sdk/SKILL.md` are placeholders today.

Polling state lives inside this worktree at `.garden-monitor/agoric-agoric-sdk/`.

**Collected 2026-05-13** per the monitoring safety constraint in `CLAUDE.md` § Monitoring safety constraint and `roles/COMMON.md` § Monitoring safety constraint (precipitating dispatch: [`entries/2026/05/13/053822Z-dispatch-liaison-44e029.md`](../../entries/2026/05/13/053822Z-dispatch-liaison-44e029.md)). The daemon was killed and the standing-monitor row removed from `roles/steward/AGENT.md`. The filesystem worktree at `path` above is deliberately left on disk so polling state under `.garden-monitor/` survives in case the constraint reverses; the steward no longer checks liveness for this entry. To re-arm: obtain maintainer authorization (journal `message` entry), restore the row in `roles/steward/AGENT.md` § Standing monitors and the active mapping in `roles/monitor/AGENT.md`, remove the DORMANT banner from `skills/monitor-agoric-sdk/SKILL.md`, flip this entry's `status` back to `active`, and respawn the daemon.
