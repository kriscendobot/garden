from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T06:56:50Z
watchdog_key: journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal
notice_count: 2
first_seen: 2026-11-03T11:39:47Z
last_seen: 2026-11-04T06:56:50Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-03T11:39:47Z, latest 2026-11-04T06:56:50Z).
The SAME condition (`journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/library-link-check/journal: p95=19.087712s max=19.087712s; hard guard=31.500000s (70% of 45s cap); remedy=none.
