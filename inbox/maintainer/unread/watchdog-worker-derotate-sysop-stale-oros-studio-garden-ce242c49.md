from_host: endolin-garden-ece02cb4
from: watchdog:worker-derotate
sent_at: 2026-11-04T10:20:18Z
watchdog_key: worker-derotate-sysop-stale-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-18T13:35:08Z
last_seen: 2026-11-04T10:20:18Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T13:35:08Z, latest 2026-11-04T10:20:18Z).
The SAME condition (`worker-derotate-sysop-stale-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Host oros-studio-garden-ce242c49 control-plane operations are UNAVAILABLE: unlogged sysop op 20261104T100535Z-8da5c7 is 602s old (stale threshold 120s). Its budget heartbeat may still be fresh; worker-derotate will remove its capacity after confirmation. Inspect garden-sysop.service/timer and the addressed operation. (leader=endolin-garden-ece02cb4)
