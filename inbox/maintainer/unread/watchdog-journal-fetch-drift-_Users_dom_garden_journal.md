from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:26:06Z
watchdog_key: journal-fetch-drift-_Users_dom_garden_journal
notice_count: 5
first_seen: 2026-11-03T10:24:17Z
last_seen: 2026-11-04T11:26:06Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-03T10:24:17Z, latest 2026-11-04T11:26:06Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: oldest-third median=2.559176s newest-third median=13.704635s over 19816s/19 samples; floor=10s, 1.5x rise or projected-to-guard=31639s within 86400s.
