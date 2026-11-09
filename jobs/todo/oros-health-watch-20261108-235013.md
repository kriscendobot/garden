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

<!-- garden-transient-elapsed: kind=exit0 through=0 values=382 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-09T00:13:05Z -->
