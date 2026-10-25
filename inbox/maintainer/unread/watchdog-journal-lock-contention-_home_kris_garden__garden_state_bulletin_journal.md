from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-25T08:48:26Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal
notice_count: 4
first_seen: 2026-10-17T11:18:19Z
last_seen: 2026-10-25T08:48:26Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-17T11:18:19Z, latest 2026-10-25T08:48:26Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.013862s, giveups=1, steals=0 (max 3/window), wait floor=60s.
