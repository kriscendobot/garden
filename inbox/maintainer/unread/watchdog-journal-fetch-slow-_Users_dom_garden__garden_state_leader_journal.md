from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T10:20:13Z
watchdog_key: journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal
notice_count: 2
first_seen: 2026-11-03T11:39:39Z
last_seen: 2026-11-04T10:20:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-03T11:39:39Z, latest 2026-11-04T10:20:13Z).
The SAME condition (`journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: p95=14.507731s max=38.194724s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
