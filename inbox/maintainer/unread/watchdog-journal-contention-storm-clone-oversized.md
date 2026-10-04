from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-04T04:50:33Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 1
first_seen: 2026-10-04T04:50:33Z
last_seen: 2026-10-04T04:50:33Z
---
Journal contention storm on endolin-garden2-5bcdff64: 6 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/dependabot-watcher/verify: awaiting a healthy post-rebuild fetch; size=48050176B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/retire: awaiting a healthy post-rebuild fetch; size=47344640B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/verify: awaiting a healthy post-rebuild fetch; size=48037888B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fireworkers/1/journal: awaiting a healthy post-rebuild fetch; size=48944128B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/comment-watcher/verify: awaiting a healthy post-rebuild fetch; size=48939008B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: awaiting a healthy post-rebuild fetch; size=48019456B packs=1 gc.log=0; automatic remedy=none.
