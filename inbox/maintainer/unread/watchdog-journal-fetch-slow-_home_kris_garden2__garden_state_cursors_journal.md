from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-08T05:27:50Z
watchdog_key: journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal
notice_count: 2
first_seen: 2026-10-07T18:22:44Z
last_seen: 2026-10-08T05:27:50Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-07T18:22:44Z, latest 2026-10-08T05:27:50Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/cursors/journal: p95=1.979051s max=32.950664s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
