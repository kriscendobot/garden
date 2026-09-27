from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T14:45:45Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 2
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-27T14:45:45Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T12:33:19Z, latest 2026-09-27T14:45:45Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=9.017134s newest-third median=17.680824s over 4905s/256 samples; floor=10s, 1.5x rise or projected-to-guard=7824s within 86400s.
