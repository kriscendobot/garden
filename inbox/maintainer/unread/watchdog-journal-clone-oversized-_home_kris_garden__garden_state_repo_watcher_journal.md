from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T02:03:10Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal
notice_count: 3
first_seen: 2026-09-26T02:35:01Z
last_seen: 2026-09-28T02:03:10Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-26T02:35:01Z, latest 2026-09-28T02:03:10Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: packs 1000 >= 1000; size=387051520B packs=1000 gc.log=0; automatic remedy=deferred.
