---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1797 applies only a fixed 300-second cooldown after source timeouts; the source timed out again at 03:33:10 and 03:48:28, repeatedly suppressing unrelated gh-api watchers. Persist a host-scoped consecutive-timeout strike count and exponentially extend the shared cooldown, resetting it only after a successful source sweep. Keep the cursor frozen and retain the existing single-warning behavior.
