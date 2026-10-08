from_host: endolin-garden2-5bcdff64
from: gauntlet:kriscendobot-minion-town-pr130-screen-d24effe2-gauntlet-not-viable
msg_key: kriscendobot-minion-town-pr130-screen-d24effe2-gauntlet-not-viable
notice_count: 1
first_seen: 2026-10-08T04:23:07Z
last_seen: 2026-10-08T04:23:09Z
sent_at: 2026-10-08T04:23:09Z
---
Gauntlet kriscendobot-minion-town-pr130-screen-d24effe2-gauntlet REFUSED by its pre-spend viability gate: the premise was overtaken. Deciding question: Does current `main`'s `deploy/aws/scripts/deploy-endo-daemon.sh` still lack both protections #130 adds: (a) the health probe must not call the auto-starting `endo list` until the supervised socket is live, and (b) stray or orphaned daemon workers must be reaped before the tree swap and restart? Option: close as superseded.
