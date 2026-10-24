from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T01:16:25Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal
notice_count: 2
first_seen: 2026-10-17T11:18:19Z
last_seen: 2026-10-24T01:16:25Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-17T11:18:19Z, latest 2026-10-24T01:16:25Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.013333s, giveups=1, steals=0 (max 3/window), wait floor=60s.
