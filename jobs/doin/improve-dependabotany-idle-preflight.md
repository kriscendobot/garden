---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
Add a deterministic preflight that exits 2 when the watched repo has no open Dependabot PRs and no due ledger rows; wire the daily backstop schedule to it. This prevents routine no-op botanist jobs and verbose clean-confirmation journal entries while preserving fail-open behavior on API errors.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-13T16:51:01Z
