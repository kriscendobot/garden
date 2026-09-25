---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/systemd/garden-ci-watcher@.service
The 2026-09-24T11:32:07Z fix (adea391f9540) added an `ExecStopPost=-/bin/bash cgroup-drain.sh %n` backstop to comment-watcher/issue-inbox/dependabot units so a straggler git surviving `KillMode=mixed`'s TERM can't leak into the next start's cgroup, but it never touched `garden-ci-watcher@.service` or `garden-triager@.service` (both have `KillMode=mixed` + `TimeoutStopSec` but no `ExecStopPost`). Since that fix landed, "Found left-over process (git) in control group while starting unit" has recurred 6 times on garden-ci-watcher@ and 9 times on garden-triager@ (journalctl 2026-09-24T11:32–2026-09-25T04:00), the identical symptom the fix was built to eliminate. Add `ExecStopPost=-/bin/bash @GARDEN_ROOT@/scripts/jobs/cgroup-drain.sh %n` to both unit templates, mirroring garden-comment-watcher@.service's placement (scripts/systemd/garden-comment-watcher@.service:47-58), and confirm `scripts/jobs/install-units.sh` re-renders them.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T03:54:58Z
