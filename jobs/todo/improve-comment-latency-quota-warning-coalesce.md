---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
scripts/jobs/comment-latency-watch.sh:154 relays the source quota warning, then line 277 emits a duplicate aggregate warning for the same 2026-10-04T03:42:28 primary-quota event. Capture and suppress source stderr after recognizing primary quota, retaining one coordinator-owned WARN with repository context before latching the cooldown.
