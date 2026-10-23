from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T00:15:25Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal
notice_count: 4
first_seen: 2026-10-18T00:44:40Z
last_seen: 2026-10-23T00:15:25Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-18T00:44:40Z, latest 2026-10-23T00:15:25Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=1.679887s max=45.036329s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
