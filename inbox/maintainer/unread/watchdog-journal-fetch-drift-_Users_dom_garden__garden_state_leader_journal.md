from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T17:02:22Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 3
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-27T17:02:22Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-27T12:33:19Z, latest 2026-09-27T17:02:22Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=6.882309s newest-third median=18.629318s over 4763s/256 samples; floor=10s, 1.5x rise or projected-to-guard=5219s within 86400s.
