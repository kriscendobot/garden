from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T14:36:00Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_triager_pace_journal
notice_count: 2
first_seen: 2026-10-20T09:21:58Z
last_seen: 2026-10-23T14:36:00Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-20T09:21:58Z, latest 2026-10-23T14:36:00Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_triager_pace_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: p95=0.014046s, giveups=1, steals=0 (max 3/window), wait floor=60s.
