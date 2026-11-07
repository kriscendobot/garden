---
handler-timeout: 3600
---

---
role: mechanic
requires: host=oros-studio-garden-ce242c49
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---

role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
target_host: oros-studio-garden-ce242c49
trigger: schedule/oros-health-checkup
mode: local
evidence: inspect locally, append one standard host-health record, and exit early for an active roll release or drain
recurrence_budget: 15 minutes

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-07T02:20:11Z
