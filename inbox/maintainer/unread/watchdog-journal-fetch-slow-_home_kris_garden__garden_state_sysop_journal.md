from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T14:00:00Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_sysop_journal
notice_count: 2
first_seen: 2026-10-23T13:21:18Z
last_seen: 2026-10-28T14:00:00Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-23T13:21:18Z, latest 2026-10-28T14:00:00Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_sysop_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=2.514776s max=34.282346s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
