---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
Defect: `scripts/jobs/journal-entry.sh:163` requires matching role, so identical claimed results at 2026-10-18T04:22:51Z and 04:23:05Z for claim `fe06a439bbcf99ad` landed once as `gardener` and once as `stylist`. For `kind: result`, suppress byte-identical bodies from the same host, job, and claim irrespective of role attribution; parse and compare `job:` alongside `claim:` in `entry_matches`. Add a regression test for mismatched role attribution under one claim, while retaining distinct-result behavior for different claims.
