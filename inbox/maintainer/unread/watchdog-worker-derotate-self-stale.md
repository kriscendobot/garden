from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-14T21:15:17Z
watchdog_key: worker-derotate-self-stale
notice_count: 1
first_seen: 2026-10-14T21:15:13Z
last_seen: 2026-10-14T21:15:17Z
---
worker-derotate FROZEN on leader endolin-garden-ece02cb4: the leader's own budget/live heartbeat reads stale (heartbeat stale by 8888s (offline threshold 1800s; sampled_at_epoch=1792003625)), so its journal view cannot be trusted to judge peers offline. No host is zeroed or restored until the leader's heartbeat is fresh again.
