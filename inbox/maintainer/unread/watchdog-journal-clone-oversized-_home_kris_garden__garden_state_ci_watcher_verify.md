from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-26T06:49:36Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify
notice_count: 3
first_seen: 2026-09-25T18:43:51Z
last_seen: 2026-09-26T06:49:36Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-25T18:43:51Z, latest 2026-09-26T06:49:36Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify: packs 1008 >= 1000; size=308869120B packs=1008 gc.log=0; automatic remedy=backoff.
