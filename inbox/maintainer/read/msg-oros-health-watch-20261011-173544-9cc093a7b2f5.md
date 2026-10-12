from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261011-173544
reply_to: oros-health-watch-20261011-173544
msg_key: msg-oros-health-watch-20261011-173544-9cc093a7b2f5
notice_count: 1
first_seen: 2026-10-11T17:50:11Z
last_seen: 2026-10-11T17:50:26Z
sent_at: 2026-10-11T17:50:26Z
---
Correction to my immediately preceding alert: oros sysop is reachable. It accepted and applied reset-failed 20261011T173829Z-e1fdef at 17:39:24Z; the ack appeared in sysop-log after the local journal projection refreshed, while the directed job inbox remained empty. No physical intervention is needed for sysop. The known stuck canary remains: oros is intentionally roll-drained on 592f66b pending maintainer diagnosis of garden-self-deploy versus main2 db962f1.
