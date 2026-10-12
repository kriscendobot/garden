from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-12T08:40:57Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal
notice_count: 4
first_seen: 2026-10-10T16:43:28Z
last_seen: 2026-10-12T08:40:57Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-10T16:43:28Z, latest 2026-10-12T08:40:57Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012882s, giveups=1, steals=0 (max 3/window), wait floor=60s.
