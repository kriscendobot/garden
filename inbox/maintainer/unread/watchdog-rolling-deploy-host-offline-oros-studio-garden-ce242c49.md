from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-09-30T22:05:01Z
watchdog_key: rolling-deploy-host-offline-oros-studio-garden-ce242c49
notice_count: 6
first_seen: 2026-09-30T20:47:15Z
last_seen: 2026-09-30T22:05:01Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-30T20:47:15Z, latest 2026-09-30T22:05:01Z).
The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1829s (offline threshold 1800s; sampled_at_epoch=1790804072).
The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
