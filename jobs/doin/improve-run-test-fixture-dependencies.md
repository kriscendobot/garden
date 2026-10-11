---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/test/run-test.sh
scripts/jobs/test/run-test.sh:280 still asserts the pre-rename `gardeners` count key, and :1137 omits `plan_deferred_status` and `admission_arc`, making the extracted deferred-plan renderer silently empty. Update the scaler assertion to the live `monks` label and extract all renderer dependencies so the suite reports real regressions and reaches later subtests.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-11T21:23:40Z
