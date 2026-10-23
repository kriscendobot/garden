from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T00:45:20Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal
notice_count: 7
first_seen: 2026-10-16T22:47:37Z
last_seen: 2026-10-23T00:45:20Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-16T22:47:37Z, latest 2026-10-23T00:45:20Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.013254s, giveups=1, steals=0 (max 3/window), wait floor=60s.
