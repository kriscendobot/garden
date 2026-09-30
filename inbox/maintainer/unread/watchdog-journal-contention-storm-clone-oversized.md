from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T21:27:55Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 1
first_seen: 2026-09-30T21:27:55Z
last_seen: 2026-09-30T21:27:55Z
---
Journal contention storm on endolin-garden-ece02cb4: 6 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: packs 1000 >= 1000; size=409749504B packs=1000 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1010 >= 1000; size=410876928B packs=1010 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: packs 1001 >= 1000; size=409463808B packs=1001 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/pages-watcher/verify: packs 1013 >= 1000; size=391076864B packs=1013 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1030 >= 1000; size=268472320B packs=1030 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1003 >= 1000; size=409834496B packs=1003 gc.log=0; automatic remedy=deferred-deadline.
