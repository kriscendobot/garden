from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-11-10T18:52:01Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-11-10T18:52:01Z
---
root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha f2788117645dde4304eb6a8dd98c59a9050ad56c is 18 commit(s) behind origin/main2 (1c72004901d7365d2faf64e48fd6cb9b21a7dd6d) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)
