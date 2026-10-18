from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-18T10:40:37Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal
notice_count: 2
first_seen: 2026-10-16T18:43:50Z
last_seen: 2026-10-18T10:40:37Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-16T18:43:50Z, latest 2026-10-18T10:40:37Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.036965s, giveups=1, steals=0 (max 3/window), wait floor=60s.
