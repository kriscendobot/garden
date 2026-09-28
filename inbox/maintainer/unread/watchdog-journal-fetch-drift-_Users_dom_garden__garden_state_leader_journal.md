from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T05:02:54Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 8
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-28T05:02:54Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T12:33:19Z, latest 2026-09-28T05:02:54Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=8.398603s newest-third median=11.376745s over 5524s/256 samples; floor=10s, 1.5x rise or projected-to-guard=37326s within 86400s.
