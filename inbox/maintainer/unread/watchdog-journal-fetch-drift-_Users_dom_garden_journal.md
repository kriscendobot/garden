from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T01:30:12Z
watchdog_key: journal-fetch-drift-_Users_dom_garden_journal
notice_count: 3
first_seen: 2026-11-03T10:24:17Z
last_seen: 2026-11-04T01:30:12Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-03T10:24:17Z, latest 2026-11-04T01:30:12Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for _Users_dom_garden_journal: oldest-third median=8.224272s newest-third median=16.895975s over 19835s/12 samples; floor=10s, 1.5x rise or projected-to-guard=33404s within 86400s.
