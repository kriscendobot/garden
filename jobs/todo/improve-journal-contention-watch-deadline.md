---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-contention-watch.sh
Add a script-owned tick deadline that reserves time to write the heartbeat and defers remaining clone analysis/remedies cleanly before the 240s unit timeout. The checker timed out under systemd, preventing its own anomaly/remedy loop from completing reliably.
