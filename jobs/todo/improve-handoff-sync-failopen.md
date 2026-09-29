---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
`scripts/jobs/assert-followup-posted.sh:105` discards `sync_clone` failure, then falsely blocks r4 at 16:12:52 although its r5 one-time schedule was committed at 16:11:55. Treat an unsuccessful sync as inconclusive and fail open, with a diagnostic log, rather than checking stale board state.
