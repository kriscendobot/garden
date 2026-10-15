from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T04:43:09Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_regenerate_sections_index_journal
notice_count: 2
first_seen: 2026-10-15T04:40:40Z
last_seen: 2026-10-15T04:43:09Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-15T04:40:40Z, latest 2026-10-15T04:43:09Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_regenerate_sections_index_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=45.001154s max=45.001154s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
