from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T01:23:57Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 7
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-28T01:23:57Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T12:33:19Z, latest 2026-09-28T01:23:57Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=20.330775s newest-third median=22.889472s over 4875s/256 samples; floor=10s, 1.5x rise or projected-to-guard=16405s within 86400s.
