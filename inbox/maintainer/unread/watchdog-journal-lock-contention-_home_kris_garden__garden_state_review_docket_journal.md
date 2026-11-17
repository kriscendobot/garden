from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-17T18:48:59Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal
notice_count: 5
first_seen: 2026-11-13T04:44:14Z
last_seen: 2026-11-17T18:48:59Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-13T04:44:14Z, latest 2026-11-17T18:48:59Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.019907s, giveups=1, steals=0 (max 3/window), wait floor=60s.
