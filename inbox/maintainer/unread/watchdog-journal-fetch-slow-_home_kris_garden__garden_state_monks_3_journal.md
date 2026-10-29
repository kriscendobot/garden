from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T13:53:24Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_monks_3_journal
notice_count: 2
first_seen: 2026-10-28T21:52:25Z
last_seen: 2026-10-29T13:53:24Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-28T21:52:25Z, latest 2026-10-29T13:53:24Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_monks_3_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/3/journal: p95=2.361426s max=31.631043s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
