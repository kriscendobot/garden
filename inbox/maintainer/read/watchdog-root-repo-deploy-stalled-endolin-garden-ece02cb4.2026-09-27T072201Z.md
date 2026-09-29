from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-09-27T07:22:01Z
watchdog_key: root-repo-deploy-stalled-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-08-08T15:52:01Z
last_seen: 2026-09-27T07:22:01Z
---
root repo /home/kris/garden deploy has been STALLED for ~0d / 25 commits behind (leader commits-fuse 25): deployed sha 47b41af5a14d9154b86fc7444ce829f99d2b9795 is 25 commit(s) behind origin/main2 (c942c685af2289f7a69820ecd57e22e0f53249ee) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)
