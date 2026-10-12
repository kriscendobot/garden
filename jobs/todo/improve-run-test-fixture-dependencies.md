---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/test/run-test.sh
scripts/jobs/test/run-test.sh:280 still asserts the pre-rename `gardeners` count key, and :1137 omits `plan_deferred_status` and `admission_arc`, making the extracted deferred-plan renderer silently empty. Update the scaler assertion to the live `monks` label and extract all renderer dependencies so the suite reports real regressions and reaches later subtests.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-12T01:43:05Z -->
