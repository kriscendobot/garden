from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T16:54:25Z
watchdog_key: journal-contention-storm-push-contention
notice_count: 19
first_seen: 2026-11-04T11:19:06Z
last_seen: 2026-11-04T16:54:25Z
---
WATCHDOG notice — occurrence #19 (first seen 2026-11-04T11:19:06Z, latest 2026-11-04T16:54:25Z).
The SAME condition (`journal-contention-storm-push-contention`) has now been observed 19 times; this is ONE
coalesced notice that updates in place, not 19 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit push-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: attempts p95=- max=- (cap 50), classes cas=3 server-reject=1 definite-fail=3.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: attempts p95=5.000000 max=5.000000 (cap 50), classes cas=9 server-reject=0 definite-fail=0.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: attempts p95=- max=- (cap 50), classes cas=7 server-reject=4 definite-fail=13.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worker-derotate/journal: attempts p95=- max=- (cap 50), classes cas=2 server-reject=0 definite-fail=1.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: attempts p95=- max=- (cap 50), classes cas=173 server-reject=0 definite-fail=11.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: attempts p95=- max=- (cap 50), classes cas=14 server-reject=2 definite-fail=12.
