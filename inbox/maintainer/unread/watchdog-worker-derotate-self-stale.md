from_host: endolin-garden2-5bcdff64
from: watchdog:worker-derotate
sent_at: 2026-10-07T05:18:04Z
watchdog_key: worker-derotate-self-stale
notice_count: 1
first_seen: 2026-10-07T05:17:57Z
last_seen: 2026-10-07T05:18:04Z
---
worker-derotate FROZEN on leader endolin-garden2-5bcdff64: the leader's own budget/live heartbeat reads stale (heartbeat stale by 22490s (offline threshold 1800s; sampled_at_epoch=1791327787)), so its journal view cannot be trusted to judge peers offline. No host is zeroed or restored until the leader's heartbeat is fresh again.
