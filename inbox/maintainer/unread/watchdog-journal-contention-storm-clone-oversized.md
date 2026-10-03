from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T13:54:29Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 13
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T13:54:29Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T13:54:29Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal contention storm on endolin-garden2-5bcdff64: 7 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/issue-inbox/verify: awaiting a healthy post-rebuild fetch; size=47377408B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/dependabot-watcher/verify: awaiting a healthy post-rebuild fetch; size=48050176B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/retire: awaiting a healthy post-rebuild fetch; size=47344640B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/verify: awaiting a healthy post-rebuild fetch; size=48037888B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fireworkers/1/journal: awaiting a healthy post-rebuild fetch; size=48944128B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/comment-watcher/verify: awaiting a healthy post-rebuild fetch; size=48939008B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: awaiting a healthy post-rebuild fetch; size=48019456B packs=1 gc.log=0; automatic remedy=none.
