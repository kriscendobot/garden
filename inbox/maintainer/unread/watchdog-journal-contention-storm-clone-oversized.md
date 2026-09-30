from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T22:02:46Z
watchdog_key: journal-contention-storm-clone-oversized
notice_count: 3
first_seen: 2026-09-30T21:27:55Z
last_seen: 2026-09-30T22:02:46Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-30T21:27:55Z, latest 2026-09-30T22:02:46Z).
The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 9 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: awaiting a healthy post-rebuild fetch; size=183046144B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: awaiting a healthy post-rebuild fetch; size=183064576B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-moddable: awaiting a healthy post-rebuild fetch; size=183044096B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-stdio-mcp: awaiting a healthy post-rebuild fetch; size=183073792B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: awaiting a healthy post-rebuild fetch; size=183045120B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1088 >= 1000; size=273372160B packs=1088 gc.log=0; automatic remedy=applied.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-proposal-compartments: awaiting a healthy post-rebuild fetch; size=183064576B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: awaiting a healthy post-rebuild fetch; size=183064576B packs=1 gc.log=0; automatic remedy=none.
- Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: awaiting a healthy post-rebuild fetch; size=183064576B packs=1 gc.log=0; automatic remedy=none.
