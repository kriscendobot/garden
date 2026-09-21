---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/worktree-sweeper.sh
Add an internal tick deadline and graceful checkpointing around terminal-worktree verification so a slow sequence of GitHub checks cannot exceed systemd’s 30-minute start timeout; leave unswept candidates for the next tick.
