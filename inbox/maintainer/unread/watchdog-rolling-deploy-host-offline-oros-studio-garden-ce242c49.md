from_host: endolin-garden-ece02cb4
from: watchdog:rolling-deploy
sent_at: 2026-10-04T15:56:02Z
watchdog_key: rolling-deploy-host-offline-oros-studio-garden-ce242c49
notice_count: 244
first_seen: 2026-10-02T05:41:06Z
last_seen: 2026-10-04T15:56:02Z
---
WATCHDOG notice — occurrence #244 (first seen 2026-10-02T05:41:06Z, latest 2026-10-04T15:56:02Z).
The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 244 times; this is ONE
coalesced notice that updates in place, not 244 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 211646s (offline threshold 1800s; sampled_at_epoch=1790917716).
The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
no release token, deploy budget, failed-canary count, or halt. Restore the host and
its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)
