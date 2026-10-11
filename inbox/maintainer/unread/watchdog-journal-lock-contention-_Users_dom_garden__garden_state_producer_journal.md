from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T09:15:43Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 4
first_seen: 2026-10-10T19:39:41Z
last_seen: 2026-10-11T09:15:43Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-10T19:39:41Z, latest 2026-10-11T09:15:43Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=60.007522s, giveups=1, steals=0 (max 3/window), wait floor=60s.
