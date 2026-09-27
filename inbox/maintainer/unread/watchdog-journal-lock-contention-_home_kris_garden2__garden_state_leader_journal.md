from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T21:37:16Z
watchdog_key: journal-lock-contention-_home_kris_garden2__garden_state_leader_journal
notice_count: 2
first_seen: 2026-09-27T09:16:19Z
last_seen: 2026-09-27T21:37:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T09:16:19Z, latest 2026-09-27T21:37:16Z).
The SAME condition (`journal-lock-contention-_home_kris_garden2__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden2-5bcdff64 for _home_kris_garden2__garden_state_leader_journal: p95=0.049422s, giveups=59, steals=0 (max 3/window), wait floor=60s.
