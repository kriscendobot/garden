once: 2026-09-29T11:30:00Z
job_basename_prefix: ironhorse-ratchet-r4-timer-20260929
---
---
tier: minion
fallback-tier: minion
dispatch: automatic
---
role: gardener

# Timer: release activate-ironhorse-ratchet-autopilot-20260929-r4

This job is only a timer. It exists so that the parked job activate-ironhorse-ratchet-autopilot-20260929-r4 (plan/, gate blocked, blocked_on: ironhorse-ratchet-r4-timer-20260929) is promoted by unblock.sh when this job lands in tada/. Do NO other work. Do not touch the ironhorse-ratchet schedule, the delegation, or any PR. Write a one-line report and complete immediately.
