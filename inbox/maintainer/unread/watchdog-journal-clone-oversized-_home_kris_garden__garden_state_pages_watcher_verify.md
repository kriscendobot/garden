from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T01:26:27Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify
notice_count: 2
first_seen: 2026-09-26T21:36:13Z
last_seen: 2026-09-27T01:26:27Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-26T21:36:13Z, latest 2026-09-27T01:26:27Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/pages-watcher/verify: gc.log present; size=225010688B packs=51 gc.log=1; automatic remedy=deferred.
