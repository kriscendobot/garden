from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T20:55:08Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal
notice_count: 18
first_seen: 2026-10-16T22:47:37Z
last_seen: 2026-10-30T20:55:08Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-10-16T22:47:37Z, latest 2026-10-30T20:55:08Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.014666s, giveups=1, steals=0 (max 3/window), wait floor=60s.
