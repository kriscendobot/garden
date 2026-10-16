from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T22:46:03Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal
notice_count: 10
first_seen: 2026-10-10T16:43:28Z
last_seen: 2026-10-15T22:46:03Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-10-10T16:43:28Z, latest 2026-10-15T22:46:03Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012313s, giveups=1, steals=0 (max 3/window), wait floor=60s.
