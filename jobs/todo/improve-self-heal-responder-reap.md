---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/self-heal-run.sh
Run the diagnostic responder in an isolated, tracked process group and reap it on TERM/INT/EXIT. A watcher restart can currently kill the wrapper while its `claude` responder survives in the unit cgroup, causing repeated left-over-process warnings and failed watcher starts.
