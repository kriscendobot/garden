from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-25T14:42:10Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal
notice_count: 8
first_seen: 2026-10-16T18:44:04Z
last_seen: 2026-10-25T14:42:10Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-16T18:44:04Z, latest 2026-10-25T14:42:10Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.076454s, giveups=1, steals=0 (max 3/window), wait floor=60s.
