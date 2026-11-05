from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T06:46:19Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal
notice_count: 3
first_seen: 2026-11-01T08:44:33Z
last_seen: 2026-11-05T06:46:19Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-01T08:44:33Z, latest 2026-11-05T06:46:19Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.061490s, giveups=1, steals=0 (max 3/window), wait floor=60s.
