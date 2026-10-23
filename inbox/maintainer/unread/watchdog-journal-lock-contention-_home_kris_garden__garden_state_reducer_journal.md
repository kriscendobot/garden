from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T04:45:25Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_reducer_journal
notice_count: 6
first_seen: 2026-10-17T00:42:48Z
last_seen: 2026-10-23T04:45:25Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-17T00:42:48Z, latest 2026-10-23T04:45:25Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_reducer_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.015780s, giveups=1, steals=0 (max 3/window), wait floor=60s.
