---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/install-units.sh
Make excluded units actively stop and disable during install/reconciliation, not merely omit them from the enable set. The deliberately paused ironhorse fuzz timer remained armed and launched a tick that systemd killed after its start timeout.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T21:22:25Z
