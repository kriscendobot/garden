---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
scripts/jobs/issue-inbox-watcher.sh:681 classifies a synthetic admission refusal as a new primary-quota outage, although the 2026-10-15T06:08:26Z diagnostic says a primary cooldown was already live. Mirror comment-watcher.sh’s latch-first handling: freeze the cursor and exit quietly when a live primary cooldown covers the failed source, before inspecting rate-limit text or extending the cooldown. Add a regression case for the race so sibling watchers preserve the original cooldown deadline and emit only its owner’s warning.
