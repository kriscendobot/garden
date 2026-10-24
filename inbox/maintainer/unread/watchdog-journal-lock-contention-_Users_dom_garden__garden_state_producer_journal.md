from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T18:45:51Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 5
first_seen: 2026-10-20T14:45:29Z
last_seen: 2026-10-24T18:45:51Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-20T14:45:29Z, latest 2026-10-24T18:45:51Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=5.042695s, giveups=1, steals=0 (max 3/window), wait floor=60s.
