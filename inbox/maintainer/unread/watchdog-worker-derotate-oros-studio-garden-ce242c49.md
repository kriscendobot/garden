from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-09-30T08:35:16Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 3
first_seen: 2026-09-29T22:20:09Z
last_seen: 2026-09-30T08:35:16Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-29T22:20:09Z, latest 2026-09-30T08:35:16Z).
The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 2795s (offline threshold 1800s; sampled_at_epoch=1790754509).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
