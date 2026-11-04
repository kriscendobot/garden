from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T23:21:36Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 6
first_seen: 2026-11-01T05:22:49Z
last_seen: 2026-11-04T23:21:36Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-01T05:22:49Z, latest 2026-11-04T23:21:36Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=44.834409s, giveups=0, steals=0 (max 3/window), wait floor=60s.
