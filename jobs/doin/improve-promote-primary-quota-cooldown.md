---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Defect: `scripts/jobs/common.sh:1146` refuses to extend any live cooldown, so the receipt watcher’s 300s transient latch at 12:24:38 can mask mirror-closer’s confirmed 3600s primary-quota latch in the same tick. Promote a live shorter all-scope marker when a primary-quota detector requests a longer window, atomically under the existing flock, while retaining no-extension behavior for ordinary transient callers. Add regression coverage for short-latch-then-primary-quota ordering so REST watchers remain suppressed for the full quota window.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T12:52:33Z
