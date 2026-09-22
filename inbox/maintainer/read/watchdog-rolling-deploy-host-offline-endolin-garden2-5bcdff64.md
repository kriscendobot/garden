from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-22T22:38:17Z
watchdog_key: rolling-deploy-host-offline-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-22T22:38:06Z
last_seen: 2026-09-22T22:38:17Z
---
Host endolin-garden2-5bcdff64 is OFFLINE: heartbeat stale by 1884s (offline threshold 1800s; sampled_at_epoch=1790114801).
The authority is budget/live/<pool>/endolin-garden2-5bcdff64, refreshed periodically; fleet/health/endolin-garden2-5bcdff64 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/endolin-garden2-5bcdff64 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
