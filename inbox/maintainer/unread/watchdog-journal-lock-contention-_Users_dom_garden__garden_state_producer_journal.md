from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T02:40:46Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 6
first_seen: 2026-10-10T19:39:41Z
last_seen: 2026-10-15T02:40:46Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-10T19:39:41Z, latest 2026-10-15T02:40:46Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=81.628819s, giveups=1, steals=2 (max 3/window), wait floor=60s.
