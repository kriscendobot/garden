---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-producer-pr-draft.sh
Gate only producer completions: deterministically exempt attention/review-feedback jobs that merely edit or acknowledge an existing PR. The current report-only PR extraction misclassifies such a job as its producer, blocks completion, and causes futile reaper retries.
