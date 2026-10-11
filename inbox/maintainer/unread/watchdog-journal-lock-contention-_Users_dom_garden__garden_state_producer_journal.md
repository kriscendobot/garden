from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T05:21:27Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 3
first_seen: 2026-10-10T19:39:41Z
last_seen: 2026-10-11T05:21:27Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-10T19:39:41Z, latest 2026-10-11T05:21:27Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=70.248492s, giveups=0, steals=0 (max 3/window), wait floor=60s.
