from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T16:39:16Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify
notice_count: 2
first_seen: 2026-09-25T00:18:10Z
last_seen: 2026-09-25T16:39:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-25T00:18:10Z, latest 2026-09-25T16:39:16Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/maintainer-approval/verify: packs 1010 >= 1000; size=222831616B packs=1010 gc.log=0; automatic remedy=applied.
