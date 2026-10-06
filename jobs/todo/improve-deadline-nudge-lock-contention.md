---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
scripts/jobs/deadline-nudge.sh:40 and :57 call clone/sync with hard clone-lock acquisition despite this being a courtesy timer, causing the 2026-10-06T04:02:00Z FATAL after three 60-second waits. Use a short soft lock for those prerequisite stages and treat live-lock contention as a clean deferred tick while retaining the existing retry behavior for real failures.
