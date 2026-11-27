from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-27T14:42:29Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal
notice_count: 9
first_seen: 2026-11-14T00:43:02Z
last_seen: 2026-11-27T14:42:29Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-11-14T00:43:02Z, latest 2026-11-27T14:42:29Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.020635s, giveups=1, steals=0 (max 3/window), wait floor=60s.
