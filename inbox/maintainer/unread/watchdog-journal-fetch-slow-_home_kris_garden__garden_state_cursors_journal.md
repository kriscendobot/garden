from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T14:03:34Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal
notice_count: 3
first_seen: 2026-10-27T18:36:44Z
last_seen: 2026-10-29T14:03:34Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-27T18:36:44Z, latest 2026-10-29T14:03:34Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: p95=2.352901s max=38.106487s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
