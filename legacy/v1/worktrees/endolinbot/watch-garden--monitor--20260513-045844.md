---
hostname: endolinbot
worktree: watch-garden--monitor--20260513-045844
path: /home/kris/worktrees/kriskowal-garden/watch-garden--monitor--20260513-045844
repo: kriskowal/garden
branch: main
role: monitor
status: collected
created_at: 2026-05-13T04:58:44Z
last_heartbeat: 2026-05-13T04:58:44Z
collected_at: 2026-05-13T05:38:22Z
task: "Monitor kriskowal/garden events feed; per-project reactions in skills/monitor-garden/SKILL.md; NEW lines dispatch a liaison subagent (asymmetric among the standing monitors)"
prs: []
---

Standing monitor for `kriskowal/garden` (slug `garden`). Polling daemon lives at `/tmp/garden-monitor-kriskowal-garden.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-garden/SKILL.md`.

Unique among the five standing monitors: on a `NEW` line from this daemon, the steward dispatches a `liaison` subagent (purpose slug `react-to-garden-issue-<N>`), not a `monitor` subagent. Reason: issue activity on this repo is meta-evolution work and routes to the liaison's authority directly. See `skills/monitor-garden/SKILL.md` § Dispatch role asymmetry for the full rationale.

Polling state lives inside this worktree at `.garden-monitor/kriskowal-garden/` and is excluded from `git status` in any worktree of the shared admin tree via `.garden/` in `/home/kris/.git/info/exclude`.

**Collected 2026-05-13** per the monitoring safety constraint in `CLAUDE.md` § Monitoring safety constraint and `roles/COMMON.md` § Monitoring safety constraint (precipitating dispatch: [`entries/2026/05/13/053822Z-dispatch-liaison-44e029.md`](../../entries/2026/05/13/053822Z-dispatch-liaison-44e029.md)). The daemon was killed and the standing-monitor row removed from `roles/steward/AGENT.md`. The filesystem worktree at `path` above is deliberately left on disk so polling state under `.garden-monitor/` survives in case the constraint reverses; the steward no longer checks liveness for this entry. To re-arm: obtain maintainer authorization (journal `message` entry), restore the row in `roles/steward/AGENT.md` § Standing monitors and the active mapping in `roles/monitor/AGENT.md`, remove the DORMANT banner from `skills/monitor-garden/SKILL.md`, flip this entry's `status` back to `active`, and respawn the daemon.
