from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T06:19:16Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal
notice_count: 2
first_seen: 2026-10-18T00:44:40Z
last_seen: 2026-10-18T06:19:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T00:44:40Z, latest 2026-10-18T06:19:16Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=1.484322s max=47.816499s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
