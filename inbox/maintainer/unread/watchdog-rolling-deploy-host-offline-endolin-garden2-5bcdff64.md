from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-15T03:20:02Z
watchdog_key: rolling-deploy-host-offline-endolin-garden2-5bcdff64
notice_count: 2338
first_seen: 2026-10-10T04:05:32Z
last_seen: 2026-10-15T03:20:02Z
---
WATCHDOG notice — occurrence #2338 (first seen 2026-10-10T04:05:32Z, latest 2026-10-15T03:20:02Z).
The SAME condition (`rolling-deploy-host-offline-endolin-garden2-5bcdff64`) has now been observed 2338 times; this is ONE
coalesced notice that updates in place, not 2338 messages. Latest detail:

Host endolin-garden2-5bcdff64 is OFFLINE: heartbeat stale by 431205s (offline threshold 1800s; sampled_at_epoch=1791603197).
The authority is budget/live/<pool>/endolin-garden2-5bcdff64, refreshed periodically; fleet/health/endolin-garden2-5bcdff64 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/endolin-garden2-5bcdff64 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
