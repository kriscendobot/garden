---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/review-docket-pr-gh.sh
Defect: `scripts/jobs/handlers/review-docket-pr-gh.sh:7` makes every docket metadata read depend on `statusCheckRollup`, which the active PAT rejects at 13:19:32Z and prevents PR #167/#188 updates. Add a permission-aware fallback that preserves trusted head/state/review metadata and derives CI through an authorized endpoint, with a regression test for the GraphQL 403.
