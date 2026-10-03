---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:2373 reopens a parked monk pool solely because its credential file changed, but the 2026-10-03T18:16:47Z recovery was followed by the same OAuth-refresh rejection at 18:17:28Z.
Before removing an `auth-failure` marker, run a bounded, credential-validating Claude auth-status probe; retain the marker and suppress the false recovery if it fails.
Add a hermetic regression case covering changed-but-still-invalid credentials. 
