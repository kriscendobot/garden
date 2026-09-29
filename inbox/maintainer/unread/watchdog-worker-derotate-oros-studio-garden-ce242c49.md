from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-09-29T01:05:11Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-09-29T01:05:08Z
last_seen: 2026-09-29T01:05:11Z
---
Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 3097s (offline threshold 1800s; sampled_at_epoch=1790640807).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
