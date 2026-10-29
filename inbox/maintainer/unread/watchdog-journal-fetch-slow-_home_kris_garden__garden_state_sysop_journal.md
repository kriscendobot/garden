from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T14:08:24Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_sysop_journal
notice_count: 5
first_seen: 2026-10-23T13:21:18Z
last_seen: 2026-10-29T14:08:24Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-23T13:21:18Z, latest 2026-10-29T14:08:24Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_sysop_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.697208s max=41.786590s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
