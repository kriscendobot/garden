---
hostname: endolinbot
worktree: watch-endo-but-for-bots--monitor--20260512-233307
path: /home/kris/worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307
repo: endojs/endo-but-for-bots
branch: llm
role: monitor
status: active
created_at: 2026-05-12T23:33:07Z
last_heartbeat: 2026-05-12T23:33:29Z
task: "Monitor endojs/endo-but-for-bots events feed (30s cadence); per-project reactions in skills/monitor-endo-but-for-bots/SKILL.md"
prs: []
---

Standing monitor for `endojs/endo-but-for-bots`. Faster cadence (30s) than the other repos because this is the active bot-evolution surface; events here often drive the maintainer's next prompt. Polling daemon lives at `/tmp/garden-monitor-endojs-endo-but-for-bots.{pid,log,err}` and is respawned by the steward per `roles/steward/AGENT.md` § Standing monitors. Per-project reaction rules in `skills/monitor-endo-but-for-bots/SKILL.md` are placeholders today.

Polling state lives inside this worktree at `.garden-monitor/endojs-endo-but-for-bots/`.
