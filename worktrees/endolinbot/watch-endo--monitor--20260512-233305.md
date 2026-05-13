---
hostname: endolinbot
worktree: watch-endo--monitor--20260512-233305
path: /home/kris/worktrees/endojs-endo/watch-endo--monitor--20260512-233305
repo: endojs/endo
branch: master
role: monitor
status: collected
created_at: 2026-05-12T23:33:05Z
last_heartbeat: 2026-05-13T02:30:03Z
collected_at: 2026-05-13T05:38:22Z
task: "Monitor endojs/endo events feed; per-project reactions in skills/monitor-endo/SKILL.md"
prs: []
---

Standing monitor for `endojs/endo`. Polling daemon lives at `/tmp/garden-monitor-endojs-endo.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-endo/SKILL.md` are placeholders today; the monitor proposes rules via `message` to liaison as it encounters event classes.

Polling state lives inside this worktree at `.garden-monitor/endojs-endo/` and is excluded from the upstream's working tree via the bare clone's `info/exclude` rule on `.garden/`.

**Collected 2026-05-13** per the monitoring safety constraint in `CLAUDE.md` § Monitoring safety constraint and `roles/COMMON.md` § Monitoring safety constraint (precipitating dispatch: [`entries/2026/05/13/053822Z-dispatch-liaison-44e029.md`](../../entries/2026/05/13/053822Z-dispatch-liaison-44e029.md)). The daemon was killed and the standing-monitor row removed from `roles/steward/AGENT.md`. The filesystem worktree at `path` above is deliberately left on disk so polling state under `.garden-monitor/` survives in case the constraint reverses; the steward no longer checks liveness for this entry. To re-arm: obtain maintainer authorization (journal `message` entry), restore the row in `roles/steward/AGENT.md` § Standing monitors and the active mapping in `roles/monitor/AGENT.md`, remove the DORMANT banner from `skills/monitor-endo/SKILL.md`, flip this entry's `status` back to `active`, and respawn the daemon.
