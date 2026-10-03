from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T07:22:02Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 3
first_seen: 2026-10-03T05:14:59Z
last_seen: 2026-10-03T07:22:02Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-03T05:14:59Z, latest 2026-10-03T07:22:02Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 12 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 12 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-cosgov: packs 1002 >= 1000; size=347553792B packs=1002 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1138 >= 1000; size=305934336B packs=1138 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1008 >= 1000; size=349976576B packs=1008 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: packs 1015 >= 1000; size=349635584B packs=1015 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: packs 1016 >= 1000; size=349814784B packs=1016 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1027 >= 1000; size=283065344B packs=1027 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ocapn: packs 1027 >= 1000; size=348709888B packs=1027 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: packs 1028 >= 1000; size=352235520B packs=1028 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: packs 1015 >= 1000; size=350629888B packs=1015 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1015 >= 1000; size=349840384B packs=1015 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: packs 1009 >= 1000; size=350013440B packs=1009 gc.log=0; automatic remedy=deferred-deadline.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-list: packs 1012 >= 1000; size=351611904B packs=1012 gc.log=0; automatic remedy=deferred-deadline.
