from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-14T22:40:37Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal
notice_count: 11
first_seen: 2026-11-06T04:41:40Z
last_seen: 2026-11-14T22:40:37Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-11-06T04:41:40Z, latest 2026-11-14T22:40:37Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.015345s, giveups=1, steals=0 (max 3/window), wait floor=60s.
