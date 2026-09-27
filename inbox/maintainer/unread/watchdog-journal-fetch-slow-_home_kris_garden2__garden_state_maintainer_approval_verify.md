from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T07:42:01Z
watchdog_key: journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify
notice_count: 2
first_seen: 2026-09-26T05:28:27Z
last_seen: 2026-09-27T07:42:01Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-26T05:28:27Z, latest 2026-09-27T07:42:01Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/maintainer-approval/verify: p95=38.567137s max=38.567137s; hard guard=31.500000s (70% of 45s cap); remedy=deferred.
