---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/worktree-sweeper.sh
Add an internal tick deadline and graceful checkpointing around terminal-worktree verification so a slow sequence of GitHub checks cannot exceed systemd’s 30-minute start timeout; leave unswept candidates for the next tick.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T22:30:29Z
