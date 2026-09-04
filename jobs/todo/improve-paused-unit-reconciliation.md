---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/install-units.sh
Make excluded units actively stop and disable during install/reconciliation, not merely omit them from the enable set. The deliberately paused ironhorse fuzz timer remained armed and launched a tick that systemd killed after its start timeout.
