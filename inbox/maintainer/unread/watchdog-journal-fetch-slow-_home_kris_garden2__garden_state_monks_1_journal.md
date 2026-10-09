from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-09T05:49:18Z
watchdog_key: journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal
notice_count: 2
first_seen: 2026-10-09T02:59:30Z
last_seen: 2026-10-09T05:49:18Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-09T02:59:30Z, latest 2026-10-09T05:49:18Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/monks/1/journal: p95=1.923607s max=35.732799s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
