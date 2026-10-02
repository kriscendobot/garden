from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-02T04:05:09Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 4
first_seen: 2026-10-01T21:35:10Z
last_seen: 2026-10-02T04:05:09Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-01T21:35:10Z, latest 2026-10-02T04:05:09Z).
The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 3457s (offline threshold 1800s; sampled_at_epoch=1790910446).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
