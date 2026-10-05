---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/ci-pr-source-gh.sh
scripts/jobs/handlers/ci-pr-source-gh.sh:61 independently enumerates the same complete REST PR list for CI and Dependabot; both hit primary-quota exhaustion at 2026-10-05T03:54:21Z.
Add a locked, short-lived per-repository complete-response cache so concurrent consumers reuse only validated successful snapshots, while failed or incomplete enumerations never populate the cache.
