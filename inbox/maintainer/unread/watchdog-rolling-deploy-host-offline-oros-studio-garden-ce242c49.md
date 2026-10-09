from_host: endolin-garden2-5bcdff64
from: watchdog:rolling-deploy
sent_at: 2026-10-09T03:17:05Z
watchdog_key: rolling-deploy-host-offline-oros-studio-garden-ce242c49
notice_count: 12
first_seen: 2026-10-08T20:53:04Z
last_seen: 2026-10-09T03:17:05Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-10-08T20:53:04Z, latest 2026-10-09T03:17:05Z).
The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1935s (offline threshold 1800s; sampled_at_epoch=1791513890).
The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden2-5bcdff64)
