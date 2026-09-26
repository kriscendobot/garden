from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-26T15:15:28Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_triager_pace_journal
notice_count: 2
first_seen: 2026-09-26T01:14:24Z
last_seen: 2026-09-26T15:15:28Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-26T01:14:24Z, latest 2026-09-26T15:15:28Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_triager_pace_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_triager_pace_journal: p95=0.001996s, giveups=1, steals=0 (max 3/window), wait floor=60s.
