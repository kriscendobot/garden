from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-10-02T18:52:01Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-10-02T18:52:01Z
---
root repo /home/kris/garden deploy has been STALLED for ~2d / 25 commits behind (leader commits-fuse 25): deployed sha 878c5d5299f047cc0c4619529e9a323b4c2d40df is 25 commit(s) behind origin/main2 (c2a524676504e54816e304546700114e85c88d11) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)
