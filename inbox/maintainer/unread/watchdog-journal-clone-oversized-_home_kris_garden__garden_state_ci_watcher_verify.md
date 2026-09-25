from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T06:07:58Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify
notice_count: 5
first_seen: 2026-09-24T08:06:50Z
last_seen: 2026-09-25T06:07:58Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-24T08:06:50Z, latest 2026-09-25T06:07:58Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify: packs 1000 >= 1000; size=198605824B packs=1000 gc.log=0; automatic remedy=backoff.
