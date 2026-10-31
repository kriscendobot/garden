from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-31T06:45:31Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_self_deploy_journal
notice_count: 5
first_seen: 2026-10-17T08:44:39Z
last_seen: 2026-10-31T06:45:31Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-17T08:44:39Z, latest 2026-10-31T06:45:31Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_self_deploy_journal`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.147623s, giveups=1, steals=0 (max 3/window), wait floor=60s.
