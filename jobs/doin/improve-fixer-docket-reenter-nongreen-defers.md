---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
A fixer job completed all its deliverables but was marked FAILED (rc=3) and left in doin for the reaper (entry 172828Z-error-gardener-bdf8f4, job fix-minion-town-pr180-ocap-key-audit-20261017). In `scripts/jobs/gardener.sh:896-903` the fixer review-docket re-entry copies any nonzero rc into `hrc`, so `review-docket.sh:349` ("not green; refusing fixer re-entry", return 3) fails a finished job. The PR picked by `extract_pr_refs_from_text "$report" | head -1` was the docs-only draft #203 with non-green CI, so the reaper will requeue the work and repeat the same outcome. Fix: treat rc 2 (nothing to do) and rc 3 (CI not green) as a deferral. Complete the job normally, and hand the re-entry to a retryable path such as `review-docket-request.sh` or a CI-green-triggered reconcile, so a green CI later creates the request. Keep failing the job only for hard errors (rc other than 0, 2 or 3). Also choose the re-entry PR by matching the job's own PR/branch rather than the first URL in the report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T20:31:46Z
