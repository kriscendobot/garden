from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-10T04:20:21Z
watchdog_key: worker-derotate-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-10-10T04:20:11Z
last_seen: 2026-10-10T04:20:21Z
---
Host endolin-garden2-5bcdff64 is OFFLINE: heartbeat stale by 2808s (offline threshold 1800s; sampled_at_epoch=1791603197).
worker-derotate zeroed its config/worker-leveling caps (were 4 4 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/endolin-garden2-5bcdff64. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
