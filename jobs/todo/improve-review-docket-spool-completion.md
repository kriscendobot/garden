---
posted_at: 2026-11-01T00:21:06Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1038 treats review-docket rc=76 as a handler failure, although review-docket.sh:564-568 durably spools it as retryable; at 2026-11-01T00:03:22Z this left a completed fixer in doin and emitted an error. Treat rc=76 like the existing deferred 2|3 cases, logging that the durable spool will be drained by a later transaction and completing the job. Add a regression test for fixer completion when the docket core returns 76.
