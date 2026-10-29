from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T17:43:40Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal
notice_count: 18
first_seen: 2026-10-17T08:43:16Z
last_seen: 2026-10-29T17:43:40Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-10-17T08:43:16Z, latest 2026-10-29T17:43:40Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_comment_latency_watch_journal`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.014233s, giveups=2, steals=0 (max 3/window), wait floor=60s.
