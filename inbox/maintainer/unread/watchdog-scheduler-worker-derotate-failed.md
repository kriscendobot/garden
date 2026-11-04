from_host: endolin-garden-ece02cb4
from: watchdog:scheduler
sent_at: 2026-11-04T11:05:38Z
watchdog_key: scheduler-worker-derotate-failed
notice_count: 2
first_seen: 2026-11-04T10:35:53Z
last_seen: 2026-11-04T11:05:38Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T10:35:53Z, latest 2026-11-04T11:05:38Z).
The SAME condition (`scheduler-worker-derotate-failed`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

worker-derotate controller failed on leader host endolin-garden-ece02cb4 (exit_status=75); no host's worker-leveling caps were changed by the failed tick, and leveling/dispatch continue. Run /home/kris/garden/scripts/jobs/worker-derotate.sh directly on endolin-garden-ece02cb4 to see the fault.
