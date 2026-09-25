from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T09:23:37Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal
notice_count: 2
first_seen: 2026-09-24T16:02:17Z
last_seen: 2026-09-25T09:23:37Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-24T16:02:17Z, latest 2026-09-25T09:23:37Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/repo-watcher/journal: packs 1004 >= 1000; size=306324480B packs=1004 gc.log=0; automatic remedy=applied.
