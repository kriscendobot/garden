---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reaper.sh
scripts/jobs/reaper.sh:1283 writes `failure_classification: unknown` for a quota-backoff recovery even though `doom_transient` treats `quota_recovery` as transient at line 1188, causing gauntlet.sh to halt rather than retry (2026-10-03T03:17:37Z). Classify `quota_recovery` as transient in the parked-plan frontmatter and extend the gauntlet-handoff test to cover it.
