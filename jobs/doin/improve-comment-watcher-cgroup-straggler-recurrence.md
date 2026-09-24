---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
The bounded wait-until-empty `reap_cgroup_stragglers` (landed in a6f6b82e0b, the same pattern just ported to issue-inbox/dependabot-watcher.sh in 84d6fb858d) has NOT fully closed the leak it was meant to close: garden-comment-watcher@kriscendobot-endo-but-for-bots.service still logged "Found left-over process (git) in control group while starting unit" for 3 pids at 2026-09-24T10:57:28Z, well after the fix was deployed and after multiple prior hardening rounds already documented inline in scripts/systemd/garden-comment-watcher@.service (the 09:40:35 GitHub-outage incident and the 20:57:54 incident). This is now the third distinct recurrence of the same symptom against the same unit. Investigate why a straggler can still survive the reap loop's default 3s deadline (GARDEN_COMMENT_CGROUP_REAP_DEADLINE_SECS) — likely candidates: a git process parked in D-state (uninterruptible disk/network I/O) that SIGKILL cannot immediately fell within 3s, or a child forked by a credential helper after the loop's last cgroup.procs re-read but before the loop returns. Consider (a) raising the default deadline with data from this incident, (b) logging the survivor's /proc/<pid>/{stat,cmdline} state on a deadline-exceeded exit so the next occurrence is diagnosable instead of just "best-effort", or (c) extending the TimeoutStopSec cgroup-wide SIGKILL backstop's coverage so a straggler that outlives the in-script reap is still guaranteed dead before the next 90s timer firing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T11:22:12Z
