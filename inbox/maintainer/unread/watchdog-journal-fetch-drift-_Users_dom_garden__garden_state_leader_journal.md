from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T16:37:21Z
watchdog_key: journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal
notice_count: 14
first_seen: 2026-09-27T12:33:19Z
last_seen: 2026-09-28T16:37:21Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-09-27T12:33:19Z, latest 2026-09-28T16:37:21Z).
The SAME condition (`journal-fetch-drift-_Users_dom_garden__garden_state_leader_journal`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal fetch drift on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/leader/journal: oldest-third median=23.100292s newest-third median=29.735017s over 4566s/256 samples; floor=10s, 1.5x rise or projected-to-guard=1215s within 86400s.
