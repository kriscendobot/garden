from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:19:06Z
watchdog_key: journal-contention-storm-push-contention
notice_count: 1
first_seen: 2026-11-04T11:19:06Z
last_seen: 2026-11-04T11:19:06Z
---
Journal contention storm on endolin-garden-ece02cb4: 6 clones hit push-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: attempts p95=- max=- (cap 50), classes cas=4 server-reject=2 definite-fail=8.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/decisions/journal: attempts p95=- max=- (cap 50), classes cas=5 server-reject=1 definite-fail=2.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gardener-scaler/journal: attempts p95=- max=- (cap 50), classes cas=13 server-reject=7 definite-fail=38.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: attempts p95=- max=- (cap 50), classes cas=18 server-reject=0 definite-fail=2.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: attempts p95=- max=- (cap 50), classes cas=3 server-reject=0 definite-fail=2.
- Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: attempts p95=- max=- (cap 50), classes cas=17 server-reject=9 definite-fail=51.
