---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
When a primary GitHub quota refusal occurs, arm the host-wide gh-api cooldown for the same one-hour duration as mirror-closer’s primary-quota marker (extend `common.sh`’s helper as needed). The current shared 300-second cooldown expired before ci-watcher retried a known-doomed API call.
