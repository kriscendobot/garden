from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T06:59:43Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal
notice_count: 3
first_seen: 2026-11-01T15:34:52Z
last_seen: 2026-11-04T06:59:43Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-01T15:34:52Z, latest 2026-11-04T06:59:43Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.043032s, giveups=2, steals=0 (max 3/window), wait floor=60s.
