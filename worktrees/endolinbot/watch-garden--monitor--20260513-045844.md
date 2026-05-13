---
hostname: endolinbot
worktree: watch-garden--monitor--20260513-045844
path: /home/kris/worktrees/kriskowal-garden/watch-garden--monitor--20260513-045844
repo: kriskowal/garden
branch: main
role: monitor
status: active
created_at: 2026-05-13T04:58:44Z
last_heartbeat: 2026-05-13T04:58:44Z
task: "Monitor kriskowal/garden events feed; per-project reactions in skills/monitor-garden/SKILL.md; NEW lines dispatch a liaison subagent (asymmetric among the standing monitors)"
prs: []
---

Standing monitor for `kriskowal/garden` (slug `garden`). Polling daemon lives at `/tmp/garden-monitor-kriskowal-garden.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-garden/SKILL.md`.

Unique among the five standing monitors: on a `NEW` line from this daemon, the steward dispatches a `liaison` subagent (purpose slug `react-to-garden-issue-<N>`), not a `monitor` subagent. Reason: issue activity on this repo is meta-evolution work and routes to the liaison's authority directly. See `skills/monitor-garden/SKILL.md` § Dispatch role asymmetry for the full rationale.

Polling state lives inside this worktree at `.garden-monitor/kriskowal-garden/` and is excluded from `git status` in any worktree of the shared admin tree via `.garden/` in `/home/kris/.git/info/exclude`.
