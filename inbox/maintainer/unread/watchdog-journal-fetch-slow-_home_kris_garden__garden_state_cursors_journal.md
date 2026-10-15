from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T13:56:16Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal
notice_count: 2
first_seen: 2026-10-15T04:48:16Z
last_seen: 2026-10-15T13:56:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-15T04:48:16Z, latest 2026-10-15T13:56:16Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=2.603746s max=34.842707s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
