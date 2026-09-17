---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
Launch the PR-source subtree in an isolated process group/session and make TERM/EXIT cleanup reliably terminate and reap that whole group. Systemd repeatedly found leftover sh and ssh children after watcher restarts.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T02:52:20Z
