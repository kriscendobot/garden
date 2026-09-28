---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1664 propagates a primary-quota rc 75 without opening the shared REST cooldown; the 2026-09-28T19:33:37Z warning shows comment-latency-watch opening it later. Detect the primary-quota stderr in this branch, call start_api_cooldown, and cleanly skip while preserving cursor freeze; add a regression test.
