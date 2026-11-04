from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-11-04T10:22:54Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-18T13:50:11Z
last_seen: 2026-11-04T10:22:54Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T13:50:11Z, latest 2026-11-04T10:22:54Z).
The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Host oros-studio-garden-ce242c49 is UNAVAILABLE: heartbeat stale by 2839s (offline threshold 1800s; sampled_at_epoch=1793784776).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat and sysop control plane are both available the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
