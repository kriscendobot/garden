---
withdrawn: true
withdrawn_by: liaison
withdrawn_at: 2026-11-14T04:09:52Z
withdrawn_reason: "unclaimable board clog: pinned to offline host oros-studio-garden-ce242c49, or held by the minion-town pause; inflated the foreman in-flight count so the ratchet press never promoted (maintainer directive, liaison session 2026-11-14)"
---
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
