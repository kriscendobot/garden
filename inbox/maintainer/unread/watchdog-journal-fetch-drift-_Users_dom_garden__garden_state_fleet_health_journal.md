from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T10:50:15Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_fleet_health_journal
notice_count: 2
first_seen: 2026-11-04T10:47:53Z
last_seen: 2026-11-04T10:50:15Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T10:47:53Z, latest 2026-11-04T10:50:15Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_fleet_health_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fleet-health/journal: oldest-third median=1.211240s newest-third median=13.151441s over 13977s/80 samples; floor=10s, 1.5x rise or projected-to-guard=21479s within 86400s.
