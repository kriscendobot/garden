---
hostname: endolinbot
worktree: watch-endo--monitor--20260512-233305
path: /home/kris/worktrees/endojs-endo/watch-endo--monitor--20260512-233305
repo: endojs/endo
branch: master
role: monitor
status: active
created_at: 2026-05-12T23:33:05Z
last_heartbeat: 2026-05-12T23:33:29Z
task: "Monitor endojs/endo events feed; per-project reactions in skills/monitor-endo/SKILL.md"
prs: []
---

Standing monitor for `endojs/endo`. Polling daemon lives at `/tmp/garden-monitor-endojs-endo.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-endo/SKILL.md` are placeholders today; the monitor proposes rules via `message` to liaison as it encounters event classes.

Polling state lives inside this worktree at `.garden-monitor/endojs-endo/` and is excluded from the upstream's working tree via the bare clone's `info/exclude` rule on `.garden/`.
