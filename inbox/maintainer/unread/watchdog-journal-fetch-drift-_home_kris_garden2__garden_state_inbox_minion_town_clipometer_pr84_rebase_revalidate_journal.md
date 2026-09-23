from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T21:16:48Z
watchdog_key: journal-fetch-drift-_home_kris_garden2__garden_state_inbox_minion_town_clipometer_pr84_rebase_revalidate_journal
notice_count: 2
first_seen: 2026-09-23T21:01:53Z
last_seen: 2026-09-23T21:16:48Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T21:01:53Z, latest 2026-09-23T21:16:48Z).
The SAME condition (`journal-fetch-drift-_home_kris_garden2__garden_state_inbox_minion_town_clipometer_pr84_rebase_revalidate_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch drift on endolin-garden2-5bcdff64 for _home_kris_garden2__garden_state_inbox_minion_town_clipometer_pr84_rebase_revalidate_journal: oldest-third median=1.197083s newest-third median=1.657734s; 1.5x floor=10s; projected-to-guard=83181s.
