from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-01T15:59:08Z
watchdog_key: rolling-deploy-host-offline-oros-studio-garden-ce242c49
notice_count: 79
first_seen: 2026-10-01T01:32:11Z
last_seen: 2026-10-01T15:59:08Z
---
WATCHDOG notice — occurrence #79 (first seen 2026-10-01T01:32:11Z, latest 2026-10-01T15:59:08Z).
The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 79 times; this is ONE
coalesced notice that updates in place, not 79 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1806s (offline threshold 1800s; sampled_at_epoch=1790868536).
The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
