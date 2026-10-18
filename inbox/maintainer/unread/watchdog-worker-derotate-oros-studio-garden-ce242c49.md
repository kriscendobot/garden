from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-18T13:50:11Z
watchdog_key: worker-derotate-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-10-18T13:50:11Z
last_seen: 2026-10-18T13:50:11Z
---
Host oros-studio-garden-ce242c49 is UNAVAILABLE: unlogged sysop op 20261018T132252Z-05edf6 is 1631s old (stale threshold 120s).
worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat and sysop control plane are both available the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)
