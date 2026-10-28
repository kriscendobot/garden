from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T13:47:37Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_monks_2_journal
notice_count: 3
first_seen: 2026-10-27T10:25:51Z
last_seen: 2026-10-28T13:47:37Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-27T10:25:51Z, latest 2026-10-28T13:47:37Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_monks_2_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/2/journal: p95=3.771945s max=32.653427s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
