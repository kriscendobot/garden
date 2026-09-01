---
tier: minion
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T20:53:59Z cleared=none -->

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Garden repo (main2): `run-test.sh` currently has ~30 pre-existing failures (environmental — sandbox lacks network for `github.com:kriskowal/garden.git`, a shellcheck-wrapper subtest, a foreman fill-batch block), leaving the suite red by default so it can't gate anything. Fix or properly skip the environmental failures.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T20:54:07Z
