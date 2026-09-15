---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Classify the observed provider envelope “Selected model is at capacity. Please try a different model.” as a transient provider-capacity failure, so gardener.sh requeues/backoffs rather than escalating a real handler failure. Add regression coverage alongside the existing transient-signature tests.
