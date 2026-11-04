from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T12:07:51Z
watchdog_key: journal-fetch-slow-_Users_dom_garden__garden_state_unblock_journal
notice_count: 2
first_seen: 2026-11-04T01:10:31Z
last_seen: 2026-11-04T12:07:51Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T01:10:31Z, latest 2026-11-04T12:07:51Z).
The SAME condition (`journal-fetch-slow-_Users_dom_garden__garden_state_unblock_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=16.278857s max=16.438544s; hard guard=31.500000s (70% of 45s cap); remedy=none.
