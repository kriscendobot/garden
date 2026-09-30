from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T21:47:47Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 2
first_seen: 2026-09-30T21:27:55Z
last_seen: 2026-09-30T21:47:47Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-30T21:27:55Z, latest 2026-09-30T21:47:47Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 10 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 10 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: awaiting a healthy post-rebuild fetch; size=183046144B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1016 >= 1000; size=411497472B packs=1016 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: awaiting a healthy post-rebuild fetch; size=183044096B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1004 >= 1000; size=406573056B packs=1004 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: awaiting a healthy post-rebuild fetch; size=183045120B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/pages-watcher/verify: packs 1023 >= 1000; size=392548352B packs=1023 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1060 >= 1000; size=269837312B packs=1060 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: packs 1004 >= 1000; size=409748480B packs=1004 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1009 >= 1000; size=410607616B packs=1009 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: packs 1004 >= 1000; size=411126784B packs=1004 gc.log=0; automatic remedy=applied.
