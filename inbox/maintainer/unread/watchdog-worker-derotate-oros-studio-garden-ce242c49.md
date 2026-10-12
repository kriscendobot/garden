from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-12T14:05:10Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 6
first_seen: 2026-10-09T00:20:13Z
last_seen: 2026-10-12T14:05:10Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-09T00:20:13Z, latest 2026-10-12T14:05:10Z).
The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 3186s (offline threshold 1800s; sampled_at_epoch=1791810717).
worker-derotate zeroed its config/worker-leveling caps (were 8 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
