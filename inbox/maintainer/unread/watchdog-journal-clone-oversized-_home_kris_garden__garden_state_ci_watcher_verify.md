from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-26T00:34:13Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify
notice_count: 2
first_seen: 2026-09-25T18:43:51Z
last_seen: 2026-09-26T00:34:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-25T18:43:51Z, latest 2026-09-26T00:34:13Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify: packs 1000 >= 1000; size=266521600B packs=1000 gc.log=0; automatic remedy=backoff.
