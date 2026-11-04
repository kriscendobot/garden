from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T15:50:41Z
watchdog_key: journal-contention-storm-push-contention
notice_count: 18
first_seen: 2026-11-04T11:19:06Z
last_seen: 2026-11-04T15:50:41Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-11-04T11:19:06Z, latest 2026-11-04T15:50:41Z).
The SAME condition (`journal-contention-storm-push-contention`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit push-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: attempts p95=- max=- (cap 50), classes cas=19 server-reject=2 definite-fail=14.
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/monks/1/journal: attempts p95=- max=- (cap 50), classes cas=12 server-reject=0 definite-fail=6.
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fleet-health/journal: attempts p95=- max=- (cap 50), classes cas=17 server-reject=2 definite-fail=15.
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/monks/2/journal: attempts p95=- max=- (cap 50), classes cas=4 server-reject=0 definite-fail=15.
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: attempts p95=- max=- (cap 50), classes cas=31 server-reject=4 definite-fail=26.
- Journal push contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/monks/3/journal: attempts p95=- max=- (cap 50), classes cas=18 server-reject=2 definite-fail=9.
