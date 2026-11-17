from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-17T06:43:46Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_reducer_journal
notice_count: 13
first_seen: 2026-11-06T02:46:39Z
last_seen: 2026-11-17T06:43:46Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-11-06T02:46:39Z, latest 2026-11-17T06:43:46Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_reducer_journal`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.020492s, giveups=1, steals=0 (max 3/window), wait floor=60s.
