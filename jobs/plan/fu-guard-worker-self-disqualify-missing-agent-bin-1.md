---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-19T01:33:05Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-19T01:33:05Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Garden repo (main2): `run-test.sh` currently has ~30 pre-existing failures (environmental — sandbox lacks network for `github.com:kriskowal/garden.git`, a shellcheck-wrapper subtest, a foreman fill-batch block), leaving the suite red by default so it can't gate anything. Fix or properly skip the environmental failures.
