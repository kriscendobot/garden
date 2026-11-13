from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-13T22:44:35Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_unblock_journal
notice_count: 9
first_seen: 2026-11-07T02:46:16Z
last_seen: 2026-11-13T22:44:35Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-11-07T02:46:16Z, latest 2026-11-13T22:44:35Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_unblock_journal`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.019039s, giveups=1, steals=0 (max 3/window), wait floor=60s.
