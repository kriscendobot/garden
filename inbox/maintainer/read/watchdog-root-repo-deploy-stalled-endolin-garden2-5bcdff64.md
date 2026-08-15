from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-08-08T06:22:01Z
watchdog_key: root-repo-deploy-stalled-endolin-garden2-5bcdff64
notice_count: 2
first_seen: 2026-08-04T10:22:02Z
last_seen: 2026-08-08T06:22:01Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-04T10:22:02Z, latest 2026-08-08T06:22:01Z).
The SAME condition (`root-repo-deploy-stalled-endolin-garden2-5bcdff64`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

root repo /home/kris/garden2 deploy has been STALLED for ~3d: deployed sha c7d730c3652a92b3bc4f533af5c1fd993bcb72d4 is 13 commit(s) behind origin/main2 (b771c6ff8444c1748581dddbffb8db9ae17223a0) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)
