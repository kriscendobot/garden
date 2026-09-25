from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T12:53:29Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify
notice_count: 6
first_seen: 2026-09-24T08:06:50Z
last_seen: 2026-09-25T12:53:29Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-24T08:06:50Z, latest 2026-09-25T12:53:29Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify: packs 1019 >= 1000; size=215631872B packs=1019 gc.log=0; automatic remedy=backoff.
