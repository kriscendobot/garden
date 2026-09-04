---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/self-heal-run.sh
Run the diagnostic responder in an isolated, tracked process group and reap it on TERM/INT/EXIT. A watcher restart can currently kill the wrapper while its `claude` responder survives in the unit cgroup, causing repeated left-over-process warnings and failed watcher starts.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=696 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T21:39:32Z
