from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-11T04:47:10Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal
notice_count: 6
first_seen: 2026-11-07T02:41:43Z
last_seen: 2026-11-11T04:47:10Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-07T02:41:43Z, latest 2026-11-11T04:47:10Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.017201s, giveups=1, steals=0 (max 3/window), wait floor=60s.
