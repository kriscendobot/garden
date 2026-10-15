from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-10-15T16:35:14Z
watchdog_key: worker-derotate-sysop-stale-oros-studio-garden-ce242c49
notice_count: 3
first_seen: 2026-10-14T16:50:07Z
last_seen: 2026-10-15T16:35:14Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-14T16:50:07Z, latest 2026-10-15T16:35:14Z).
The SAME condition (`worker-derotate-sysop-stale-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Host oros-studio-garden-ce242c49 control-plane operations are UNAVAILABLE: unlogged sysop op 20261015T162012Z-50e386 is 890s old (stale threshold 120s). Its budget heartbeat may still be fresh; worker-derotate will remove its capacity after confirmation. Inspect garden-sysop.service/timer and the addressed operation. (leader=endolin-garden-ece02cb4)
