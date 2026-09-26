from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-26T07:17:10Z
watchdog_key: rolling-deploy-host-offline-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-09-26T07:17:10Z
last_seen: 2026-09-26T07:17:10Z
---
Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1896s (offline threshold 1800s; sampled_at_epoch=1790405126).
The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
