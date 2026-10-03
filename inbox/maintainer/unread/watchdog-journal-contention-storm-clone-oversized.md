from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T07:56:28Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 4
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T07:56:28Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T07:56:28Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 13 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 13 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-cosgov: awaiting a healthy post-rebuild fetch; size=194413568B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1181 >= 1000; size=311376896B packs=1181 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1017 >= 1000; size=351874048B packs=1017 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: packs 1025 >= 1000; size=352989184B packs=1025 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1025 >= 1000; size=352200704B packs=1025 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: packs 1007 >= 1000; size=354334720B packs=1007 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1081 >= 1000; size=288527360B packs=1081 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ocapn: packs 1037 >= 1000; size=351572992B packs=1037 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: packs 1038 >= 1000; size=354626560B packs=1038 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: packs 1025 >= 1000; size=353508352B packs=1025 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1024 >= 1000; size=352226304B packs=1024 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: packs 1019 >= 1000; size=352877568B packs=1019 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-list: packs 1022 >= 1000; size=354486272B packs=1022 gc.log=0; automatic remedy=applied.
