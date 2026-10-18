from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T20:42:20Z
watchdog_key: journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal
notice_count: 3
first_seen: 2026-10-16T22:05:57Z
last_seen: 2026-10-18T20:42:20Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-16T22:05:57Z, latest 2026-10-18T20:42:20Z).
The SAME condition (`journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch anomaly on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: p95=3.232551s max=40.278658s; hard guard=31.500000s (70% of 45s cap); remedy=applied.
