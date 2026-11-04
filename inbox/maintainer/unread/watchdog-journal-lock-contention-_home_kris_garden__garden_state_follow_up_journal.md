from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T08:44:21Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal
notice_count: 2
first_seen: 2026-11-01T08:44:33Z
last_seen: 2026-11-04T08:44:21Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-01T08:44:33Z, latest 2026-11-04T08:44:21Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.078238s, giveups=1, steals=0 (max 3/window), wait floor=60s.
