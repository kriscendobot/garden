from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-25T10:41:56Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_producer_journal
notice_count: 6
first_seen: 2026-10-20T14:45:29Z
last_seen: 2026-10-25T10:41:56Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-20T14:45:29Z, latest 2026-10-25T10:41:56Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_producer_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=0.132390s, giveups=1, steals=0 (max 3/window), wait floor=60s.
