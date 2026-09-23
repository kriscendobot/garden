from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-09-21T23:52:14Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-09-21T23:52:14Z
---
root repo /home/kris/garden deploy has been STALLED for ~2d / 26 commits behind (leader commits-fuse 25): deployed sha 917115c9b77234e4a05db68e8c5111fe6e5b305f is 26 commit(s) behind origin/main2 (85ae2f878c47ba1a050496c31b770867113aaea1) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)
