---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
`scripts/jobs/common.sh:2403-2425` clears an auth-failure marker after one successful `claude auth status` probe; journal entries at 2026-10-03T13:32:26Z, 14:30:25Z, and 15:27:20Z reported recovery immediately followed by OAuth rejection. Require stable repeated successful probes for an unchanged credential fingerprint before un-parking, retaining the episode marker on a failed confirmation.
