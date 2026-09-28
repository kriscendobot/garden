from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T17:28:24Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_approval_reconciler_verify
notice_count: 3
first_seen: 2026-09-28T14:33:12Z
last_seen: 2026-09-28T17:28:24Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-28T14:33:12Z, latest 2026-09-28T17:28:24Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_approval_reconciler_verify`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for _home_kris_garden__garden_state_approval_reconciler_verify: p95=78.311853s, giveups=0, steals=0 (max 3/window), wait floor=60s.
