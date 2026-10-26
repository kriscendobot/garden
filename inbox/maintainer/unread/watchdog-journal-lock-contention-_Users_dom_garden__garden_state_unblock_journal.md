from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-26T10:43:31Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal
notice_count: 9
first_seen: 2026-10-16T18:44:04Z
last_seen: 2026-10-26T10:43:31Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-10-16T18:44:04Z, latest 2026-10-26T10:43:31Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.109561s, giveups=1, steals=0 (max 3/window), wait floor=60s.
