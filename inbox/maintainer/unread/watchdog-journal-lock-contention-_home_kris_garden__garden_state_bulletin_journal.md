from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T11:07:05Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal
notice_count: 3
first_seen: 2026-10-17T11:18:19Z
last_seen: 2026-10-24T11:07:05Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-17T11:18:19Z, latest 2026-10-24T11:07:05Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.013650s, giveups=1, steals=0 (max 3/window), wait floor=60s.
