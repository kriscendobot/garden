---
posted_at: 2026-11-05T17:51:35Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/decision-append.sh
Defect: `scripts/jobs/decision-append.sh:108` drops decisions when its optional 5-second clone lock wait is busy; the reaper lost `schedule-plain-retry` at 17:24:39Z and `mark-split-eligible` at 17:35:39Z.
Persist failed decision rows in a host-local durable spool and flush them under the ledger lock on a later successful invocation, retaining fail-open behavior for controllers.
Add coverage for lock contention followed by recovery to verify both rows reach the ledger once.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T17:51:47Z
