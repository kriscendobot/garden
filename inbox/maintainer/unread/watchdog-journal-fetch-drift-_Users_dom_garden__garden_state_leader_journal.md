from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T22:30:24Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 6
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-27T22:30:24Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T12:33:19Z, latest 2026-09-27T22:30:24Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=18.599392s newest-third median=22.438466s over 4535s/256 samples; floor=10s, 1.5x rise or projected-to-guard=10704s within 86400s.
