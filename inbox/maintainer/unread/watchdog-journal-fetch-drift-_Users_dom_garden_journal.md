from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T11:34:21Z
watchdog_key: journal-fetch-drift-_Users_dom_garden_journal
notice_count: 2
first_seen: 2026-11-03T10:24:17Z
last_seen: 2026-11-03T11:34:21Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-03T10:24:17Z, latest 2026-11-03T11:34:21Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: oldest-third median=4.897116s newest-third median=11.319385s over 19840s/12 samples; floor=10s, 1.5x rise or projected-to-guard=62343s within 86400s.
