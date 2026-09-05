---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Make startup cgroup cleanup re-read and discard cgroup members whose `/proc` records have vanished before classifying them as live residue or alerting. The repeated warnings are all `unknown=2`, indicating a cgroup/proc race rather than signalable survivors.
