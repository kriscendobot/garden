from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T08:11:27Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 5
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T08:11:27Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T08:11:27Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 13 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 13 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-cosgov: awaiting a healthy post-rebuild fetch; size=194413568B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1199 >= 1000; size=314112000B packs=1199 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1017 >= 1000; size=351874048B packs=1017 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: awaiting a healthy post-rebuild fetch; size=193896448B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1025 >= 1000; size=352200704B packs=1025 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: packs 1007 >= 1000; size=354334720B packs=1007 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1108 >= 1000; size=291303424B packs=1108 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ocapn: awaiting a healthy post-rebuild fetch; size=194290688B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: awaiting a healthy post-rebuild fetch; size=193885184B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: packs 1025 >= 1000; size=353508352B packs=1025 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1024 >= 1000; size=352226304B packs=1024 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: packs 1019 >= 1000; size=352877568B packs=1019 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-list: awaiting a healthy post-rebuild fetch; size=193896448B packs=1 gc.log=0; automatic remedy=none.
