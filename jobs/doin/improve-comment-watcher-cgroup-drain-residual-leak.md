---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cgroup-drain.sh
Despite the 2026-09-24 fix (commit adea391f954, confirmed deployed on endolin-garden-ece02cb4 as of HEAD 97cb307), `garden-comment-watcher@kriscendobot-proposal-compartments` still hit systemd's "Found left-over process (git) in control group while starting unit" at 2026-09-26T11:16:13Z for 3 pids — and the journalctl window contains zero `cgroup-drain[...]` log lines for that tick, meaning `ExecStopPost` either declared the cgroup empty (two consecutive 0.1s-apart empty reads, cgroup-drain.sh:~100-115) before a delayed fork landed, or never ran. The likely culprit is a `git`/`gh` credential-helper child that forks asynchronously after the main watcher process already exited and after the drain loop's second empty read, so it's invisible to the point-in-time `cgroup.procs` snapshot yet still lands in the same instance cgroup by the next 90s firing. Harden cgroup-drain.sh by requiring more than 2 consecutive empty reads spaced further apart (e.g. 3 reads over ~1s) before declaring drained, or add a final settle-check a few hundred ms after the "drained" log line to catch a fork that raced the declaration. This is now a confirmed post-fix recurrence, not deploy lag, so the residual race the script's own comments already anticipated ("uninterruptible I/O") needs a second closing case for "delayed fork after declared-empty".

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-26T11:23:21Z
