from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T09:29:32Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 7
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T09:29:32Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T09:29:32Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1282 >= 1000; size=325344256B packs=1282 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1046 >= 1000; size=360479744B packs=1046 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1052 >= 1000; size=360807424B packs=1052 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1216 >= 1000; size=302155776B packs=1216 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1051 >= 1000; size=361310208B packs=1051 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-watcher/verify: packs 1008 >= 1000; size=328997888B packs=1008 gc.log=0; automatic remedy=deferred-deadline.
