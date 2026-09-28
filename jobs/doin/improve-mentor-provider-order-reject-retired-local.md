---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh
`provider_order()` (mentor-claude.sh:77-87) still allows `local` and the default at line 28 is `GARDEN_MENTOR_PROVIDER_ORDER:=openai,local,anthropic`, wasting a probe on the retired (2026-09-13) Ollama/hermit lane on every mentor invocation. The sibling fix already landed in foreman-claude.sh (commit f3e5ea54007, job `improve-foreman-provider-order-reject-retired-local`, tada'd 2026-09-28): `provider_order()` rejects `local` with an error naming the retirement, allowed providers are `openai`/`anthropic` only. Apply the same pattern here: reject `local` in the case statement at line 83, change the default at line 28 to `openai,anthropic`, and update `foreman-provider-order-test.sh`'s sibling test file for mentor if one exists (or add one). This was explicitly flagged as a follow-up in the foreman job's own completion report but never actioned.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T12:55:48Z
