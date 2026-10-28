from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T14:00:05Z
watchdog_key: journal-fetch-slow-_home_kris_garden_journal
notice_count: 2
first_seen: 2026-10-18T12:12:29Z
last_seen: 2026-10-28T14:00:05Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T12:12:29Z, latest 2026-10-28T14:00:05Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for _home_kris_garden_journal: p95=25.478733s max=25.478733s; hard guard=31.500000s (70% of 45s cap); remedy=none.
