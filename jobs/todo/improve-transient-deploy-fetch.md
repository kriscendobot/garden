---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
scripts/jobs/deploy-garden.sh:603-604 converts a transient origin fetch failure into rc=1; at 2026-10-05T19:41:11Z rolling-deploy consequently persisted a rejection and suppressed retries for the unchanged SHA. Return `GARDEN_OFFLINE_RC` for connectivity fetch failures, and update rolling-deploy.sh to treat that code as a retry-next-tick result rather than writing a rejected marker; add coverage to rolling-deploy-test.sh.
