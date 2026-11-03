---
posted_at: 2026-11-03T19:20:38Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mirror-pr-state-gh.sh
At scripts/jobs/handlers/mirror-pr-state-gh.sh:70-98, a non-JSON body from `gh api graphql` fails with "invalid character 'b' looking for beginning of value". This is logged as "definitive, rc=1; not retrying" at 13:18:59 for Agoric/agoric-sdk#11297. The same tick then ended with garden-mirror-closer.service failing at 13:20:41. The jq parse error is almost certainly a transient HTML or proxy-error body, not a definitive miss. Classify the `invalid character ... looking for beginning of value` signature as transient in `gh_api_retry`'s retry classifier so it gets jittered retries. After retries are exhausted, exit with the quiet degrade path instead of a FATAL, so mirror-closer.sh counts it as a transient failure and the unit does not go to 'failed'.
