from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-14T09:09:03Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_bulletin_journal
notice_count: 2
first_seen: 2026-10-13T08:37:26Z
last_seen: 2026-10-14T09:09:03Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-13T08:37:26Z, latest 2026-10-14T09:09:03Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=3.063062s max=40.083617s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
