from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T00:42:39Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify
notice_count: 4
first_seen: 2026-09-24T08:06:50Z
last_seen: 2026-09-25T00:42:39Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-24T08:06:50Z, latest 2026-09-25T00:42:39Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify: packs 1010 >= 1000; size=184041472B packs=1010 gc.log=0; automatic remedy=backoff.
