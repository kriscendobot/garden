---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
When a CI rollup reports GitHub primary-quota exhaustion, open the existing host-wide API cooldown and stop the sweep. This prevents every per-repo tick from repeating doomed GraphQL reads and warnings until the quota window recovers.
