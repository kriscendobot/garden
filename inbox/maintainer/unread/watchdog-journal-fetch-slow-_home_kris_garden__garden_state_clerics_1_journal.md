from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T14:03:29Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal
notice_count: 5
first_seen: 2026-10-18T00:44:40Z
last_seen: 2026-10-29T14:03:29Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-18T00:44:40Z, latest 2026-10-29T14:03:29Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_clerics_1_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/clerics/1/journal: p95=2.317330s max=34.040022s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
