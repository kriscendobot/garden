---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
scripts/jobs/issue-inbox-watcher.sh:690 checks only a primary-quota latch, so the 2026-10-26 22:49:52 pages transient-cooldown admission refusal was misreported as a new primary quota and extended to 2489s.
Treat any live REST cooldown plus an admission-refused diagnostic as collateral; preserve its owner/deadline and emit no warning, with a regression case for a `pages:*:net` latch.
