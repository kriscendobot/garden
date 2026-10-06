from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T08:38:40Z
watchdog_key: journal-fetch-slow-_home_kris_garden_journal
notice_count: 3
first_seen: 2026-10-06T03:47:03Z
last_seen: 2026-10-06T08:38:40Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-06T03:47:03Z, latest 2026-10-06T08:38:40Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=15.450170s max=15.450170s; hard guard=31.500000s (70% of 45s cap); remedy=none.
