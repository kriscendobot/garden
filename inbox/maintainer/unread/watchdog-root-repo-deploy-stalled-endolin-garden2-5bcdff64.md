from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-09-13T05:22:02Z
watchdog_key: root-repo-deploy-stalled-endolin-garden2-5bcdff64
notice_count: 2
first_seen: 2026-08-04T10:22:02Z
last_seen: 2026-09-13T05:22:02Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-04T10:22:02Z, latest 2026-09-13T05:22:02Z).
The SAME condition (`root-repo-deploy-stalled-endolin-garden2-5bcdff64`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

root repo /home/kris/garden2 deploy has been STALLED for ~1d: deployed sha d24f8862e85c1dd4505fddf918fa8701e7c0bd7d is 8 commit(s) behind origin/main2 (f5e91b662553960d4e41ea8a305b84c544c082f0) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)
