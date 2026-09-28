from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T07:37:59Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 9
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-28T07:37:59Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-27T12:33:19Z, latest 2026-09-28T07:37:59Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=9.011906s newest-third median=12.160914s over 5301s/256 samples; floor=10s, 1.5x rise or projected-to-guard=32555s within 86400s.
