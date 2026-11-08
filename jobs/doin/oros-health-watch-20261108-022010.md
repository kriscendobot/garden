---
handler-timeout: 3600
---

---
role: mechanic
requires: host=endolin-garden-ece02cb4
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---

role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
target_host: oros-studio-garden-ce242c49
trigger: schedule/oros-health-watch
mode: controller
evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
recurrence_budget: 15 minutes

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-08T02:20:30Z
