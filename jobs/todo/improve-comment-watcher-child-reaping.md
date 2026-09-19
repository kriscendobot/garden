---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Make comment-source subprocess cleanup reliably leave the service cgroup empty across stop/restart races; a gh child still survived into the next watcher invocation despite the existing process-group and cgroup cleanup.
