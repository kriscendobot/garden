---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
The exact "left-over process (git) in control group" leak recurred today (garden-issue-inbox.service, 2026-09-24T10:04:11Z, three git children flagged at startup — the same three-orphan signature the script's own comments say was already chased once, the "00:36:21 three-orphan leak"). Root cause: `reap_cgroup_stragglers()` here (issue-inbox-watcher.sh:542-568) is a single snapshot-then-kill pass. `scripts/jobs/comment-watcher.sh` hit and fixed the identical leak class in its own `reap_cgroup_stragglers()` (comment-watcher.sh:1420-1540ish) and documented exactly why a single pass is insufficient: (1) FORK-AFTER-SNAPSHOT — `gh --paginate` forks a fresh git credential helper per page, so a child spawned after the one `cgroup.procs` read escapes the kill entirely; (2) EXIT-BEFORE-TEARDOWN — `kill -KILL` only queues the signal, so the watcher can exit and the next `systemctl start` can still observe the not-yet-reaped pid. comment-watcher.sh's fix is a bounded re-read loop (default 3s deadline, overridable) that re-reads `cgroup.procs` every pass, SIGKILLs stragglers, and only returns once the cgroup is genuinely empty — plus a zombie-aware `_straggler_alive` helper (checks `/proc/<pid>/stat` state, not just `kill -0`, since a zombie holds no cgroup slot but still answers `kill -0`).

Port that hardened bounded-loop `reap_cgroup_stragglers` + `_straggler_alive` pattern from comment-watcher.sh into issue-inbox-watcher.sh, replacing the single-pass version, so the issue-inbox watcher gets the same closed-loop guarantee instead of relying on the next start's harmless-but-noisy "Ignoring" migration. Worth also checking `scripts/jobs/ci-watcher.sh`, `scripts/jobs/pages-watcher.sh`, `scripts/jobs/dependabot-watcher.sh`, and `scripts/jobs/approval-reconciler.sh` — their comments reference the same `gh --paginate`-forks-git-credential-helpers hazard, and may carry the same stale single-pass sweep — but issue-inbox-watcher.sh is the one with a live, reproduced failure today.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T10:23:17Z
