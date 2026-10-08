---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:444 and :446 issue raw `gh api` self-test reads outside the shared admission/cooldown path; at 2026-10-08T20:36:38Z another watcher hit primary quota. Route these reads through `gh_api_retry` (while retaining the timeout bound) so primary exhaustion is latched before any further probe request.
