---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-producer-pr-draft.sh
Gate only producer completions: deterministically exempt attention/review-feedback jobs that merely edit or acknowledge an existing PR. The current report-only PR extraction misclassifies such a job as its producer, blocks completion, and causes futile reaper retries.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T16:51:07Z
