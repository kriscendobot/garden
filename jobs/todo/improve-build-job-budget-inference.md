---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-job.sh
scripts/jobs/post-job.sh must stamp `handler-budget-role: builder` for automatic job basenames ending in `-build` or `-build-<n>` when no explicit budget metadata is supplied; `fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3` received the 2400s default and deterministically timed out at 2026-10-16T19:40:12Z. This moves budget selection out of agent-authored job prose and ensures build retries receive the existing 7200s builder budget in `scripts/jobs/common.sh:10789`.
