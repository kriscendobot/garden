---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/systemd/garden-worker@.service.in
scripts/systemd/garden-worker@.service.in:63 exhausted its 2700-second graceful-stop window, and garden-monk@3 was SIGKILLed at 2026-10-08T04:04:44Z. Increase the stop allowance with a conservative bounded margin above the handler wall and kill grace, and add a regression assertion that the rendered unit cannot undercut that bound.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T04:21:21Z
