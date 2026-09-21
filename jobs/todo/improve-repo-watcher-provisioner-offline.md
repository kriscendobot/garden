---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/repo-watcher.sh
Treat fork-watch-provisioner rc=75 as a transient shared availability event with bounded deduplicated reporting, rather than emitting the same warning every reconcile tick; continue reconciling already-armed watches.
