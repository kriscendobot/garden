from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-27T13:43:37Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_monks_2_journal
notice_count: 2
first_seen: 2026-10-27T10:25:51Z
last_seen: 2026-10-27T13:43:37Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-27T10:25:51Z, latest 2026-10-27T13:43:37Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_monks_2_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monks/2/journal: p95=72.969888s max=72.969888s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.
