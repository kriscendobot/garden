from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-09-15T05:22:02Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 3
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-09-15T05:22:02Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-08-08T15:52:01Z, latest 2026-09-15T05:22:02Z).
The SAME condition (`root-repo-deploy-stalled-endolin-garden-ece02cb4`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha d24f8862e85c1dd4505fddf918fa8701e7c0bd7d is 14 commit(s) behind origin/main2 (4d51ea7f4375ee42d1428dbbb0786cbe3683d3ea) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)
