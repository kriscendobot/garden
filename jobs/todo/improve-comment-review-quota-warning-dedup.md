---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:513 emits a WARN before returning the primary-quota signal, and scripts/jobs/comment-watcher.sh:1886 emits a second WARN for the same event (23:12:42 and 23:12:47). Keep the coordinator warning only; record the handler diagnostic without WARN severity and add a regression test for one journal warning per quota incident.
