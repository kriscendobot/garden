---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Make stale-cgroup cleanup distinguish unreapable zombies from live survivors and avoid restarting worker units into the same stale descendant set every minute; reap or wait on the owning systemd cgroup where possible, then rate-limit/escalate a persistent residue instead of repeatedly SIGKILLing the same PIDs.
