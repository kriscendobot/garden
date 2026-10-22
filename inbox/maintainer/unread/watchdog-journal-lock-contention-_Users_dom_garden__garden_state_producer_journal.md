from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-22T02:48:17Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 3
first_seen: 2026-10-20T14:45:29Z
last_seen: 2026-10-22T02:48:17Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-20T14:45:29Z, latest 2026-10-22T02:48:17Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=26.350355s, giveups=1, steals=0 (max 3/window), wait floor=60s.
