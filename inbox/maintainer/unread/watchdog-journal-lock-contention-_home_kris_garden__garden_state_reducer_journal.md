from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T02:46:37Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_reducer_journal
notice_count: 14
first_seen: 2026-10-17T00:42:48Z
last_seen: 2026-10-28T02:46:37Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-10-17T00:42:48Z, latest 2026-10-28T02:46:37Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_reducer_journal`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.029995s, giveups=1, steals=0 (max 3/window), wait floor=60s.
