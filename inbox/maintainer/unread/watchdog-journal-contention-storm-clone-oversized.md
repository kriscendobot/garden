from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T06:56:23Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 2
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T06:56:23Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T06:56:23Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1107 >= 1000; size=302843904B packs=1107 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: packs 1000 >= 1000; size=347146240B packs=1000 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1002 >= 1000; size=347282432B packs=1002 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ocapn: packs 1012 >= 1000; size=346220544B packs=1012 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: packs 1013 >= 1000; size=349685760B packs=1013 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: packs 1000 >= 1000; size=348079104B packs=1000 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1000 >= 1000; size=347345920B packs=1000 gc.log=0; automatic remedy=deferred-deadline.
