from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T05:34:44Z
watchdog_key: journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal
notice_count: 2
first_seen: 2026-09-27T05:03:52Z
last_seen: 2026-09-27T05:34:44Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T05:03:52Z, latest 2026-09-27T05:34:44Z).
The SAME condition (`journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: p95=16.552820s max=24.961703s; hard guard=31.500000s (70% of 45s cap); remedy=none.
