from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-25T16:39:25Z
watchdog_key: journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify
notice_count: 5
first_seen: 2026-09-24T12:12:02Z
last_seen: 2026-09-25T16:39:25Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-24T12:12:02Z, latest 2026-09-25T16:39:25Z).
The SAME condition (`journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-watcher/verify: gc.log present; size=110974976B packs=51 gc.log=1; automatic remedy=backoff.
