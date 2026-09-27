from_host: oros-studio-garden-ce242c49
from: watchdog:root-repo-guard
sent_at: 2026-09-27T17:52:08Z
watchdog_key: root-repo-deploy-stalled-oros-studio-garden-ce242c49
notice_count: 3
first_seen: 2026-09-24T03:42:29Z
last_seen: 2026-09-27T17:52:08Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-24T03:42:29Z, latest 2026-09-27T17:52:08Z).
The SAME condition (`root-repo-deploy-stalled-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

root repo /Users/dom/garden deploy has been STALLED for ~1d: deployed sha 586aee8196b4c03fdb68c7d2368856cb756de4eb is 28 commit(s) behind origin/main2 (7bd312a6379e0de6b290b270ff3b11245f7720b9) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=oros-studio-garden-ce242c49)
