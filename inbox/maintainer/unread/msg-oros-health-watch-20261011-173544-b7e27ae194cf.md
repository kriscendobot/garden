from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261011-173544
reply_to: oros-health-watch-20261011-173544
msg_key: msg-oros-health-watch-20261011-173544-b7e27ae194cf
notice_count: 1
first_seen: 2026-10-11T17:49:47Z
last_seen: 2026-10-11T17:49:48Z
sent_at: 2026-10-11T17:49:48Z
---
Oros sysop bridge is not responding: no sysop-log activity since 13:02Z, and reset-failed 20261011T173829Z-e1fdef received no ack after 10 minutes. The host quota heartbeat is still fresh (sampled 17:01Z), but fleet/health remains stale at 12:01Z and roll-drained on 592f66b while main2 is db962f1. The rolling deploy left an active failure drain, so I did not lift it. A person should inspect garden-sysop and garden-self-deploy on oros; physical access may be needed if the VM or Docker service is unhealthy.
