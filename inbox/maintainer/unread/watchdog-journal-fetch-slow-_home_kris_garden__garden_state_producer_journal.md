from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T08:47:26Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_producer_journal
notice_count: 2
first_seen: 2026-10-18T07:14:56Z
last_seen: 2026-10-18T08:47:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T07:14:56Z, latest 2026-10-18T08:47:26Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_producer_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=48.751971s max=49.191001s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
