from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T15:34:32Z
watchdog_key: journal-contention-storm-push-contention
notice_count: 17
first_seen: 2026-11-04T11:19:06Z
last_seen: 2026-11-04T15:34:32Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-11-04T11:19:06Z, latest 2026-11-04T15:34:32Z).
The SAME condition (`journal-contention-storm-push-contention`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit push-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/decisions/journal: attempts p95=- max=- (cap 50), classes cas=2 server-reject=1 definite-fail=2.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/cursors/journal: attempts p95=5.000000 max=5.000000 (cap 50), classes cas=9 server-reject=0 definite-fail=0.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: attempts p95=- max=- (cap 50), classes cas=13 server-reject=7 definite-fail=40.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: attempts p95=- max=- (cap 50), classes cas=50 server-reject=0 definite-fail=2.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worker-derotate/journal: attempts p95=- max=- (cap 50), classes cas=2 server-reject=0 definite-fail=1.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: attempts p95=- max=- (cap 50), classes cas=20 server-reject=10 definite-fail=54.
