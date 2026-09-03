from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-09-03T02:22:02Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 2
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-09-03T02:22:02Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-08T15:52:01Z, latest 2026-09-03T02:22:02Z).
The SAME condition (`root-repo-deploy-stalled-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha 2bf8803996bd70d17c81abff3c16d127bbc89bb5 is 64 commit(s) behind origin/main2 (3cfbeb5ac433f64679608b13575d04962401a697) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)
