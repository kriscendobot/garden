from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-09-29T18:50:59Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-09-29T10:35:08Z
last_seen: 2026-09-29T18:50:59Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-29T10:35:08Z, latest 2026-09-29T18:50:59Z).
The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 2792s (offline threshold 1800s; sampled_at_epoch=1790705024).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
