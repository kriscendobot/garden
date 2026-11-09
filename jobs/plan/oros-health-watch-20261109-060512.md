---
gate: go-ahead
priority: normal
role: mechanic
tier: mentor
handler-timeout: 3600
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-09T06:33:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-09T06:33:06Z
---

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
