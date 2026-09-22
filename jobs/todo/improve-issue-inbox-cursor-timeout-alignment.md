---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
Use a cursor-specific timeout that permits cursor-get.sh’s bounded cursor-IO-lock wait plus grace, instead of killing it at the blanket 90-second stage limit. The repeated rc=124 cursor-read skips prevent the helper from returning its safe temporary-unavailable result, causing noisy retries; add a regression case for this timeout alignment.
