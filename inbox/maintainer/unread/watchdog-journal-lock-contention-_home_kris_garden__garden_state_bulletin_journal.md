from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-09T13:02:02Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal
notice_count: 5
first_seen: 2026-11-06T04:41:40Z
last_seen: 2026-11-09T13:02:02Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-06T04:41:40Z, latest 2026-11-09T13:02:02Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.060071s, giveups=1, steals=0 (max 3/window), wait floor=60s.
