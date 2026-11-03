from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T18:59:54Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 4
first_seen: 2026-11-01T05:22:49Z
last_seen: 2026-11-03T18:59:54Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-11-01T05:22:49Z, latest 2026-11-03T18:59:54Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=63.545428s, giveups=1, steals=0 (max 3/window), wait floor=60s.
