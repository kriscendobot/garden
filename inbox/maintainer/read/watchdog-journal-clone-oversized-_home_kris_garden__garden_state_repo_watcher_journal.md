from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-23T20:46:14Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal
notice_count: 2
first_seen: 2026-09-23T19:47:29Z
last_seen: 2026-09-23T20:46:14Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-23T19:47:29Z, latest 2026-09-23T20:46:14Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: packs 54 >= 50; size=55588864B packs=54 gc.log=0; automatic remedy=backoff.
