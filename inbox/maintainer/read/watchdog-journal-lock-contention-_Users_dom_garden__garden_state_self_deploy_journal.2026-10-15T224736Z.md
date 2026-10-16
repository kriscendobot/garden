from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T22:47:36Z
watchdog_key: journal-lock-contention-_Users_dom_garden__garden_state_self_deploy_journal
notice_count: 3
first_seen: 2026-10-15T02:56:08Z
last_seen: 2026-10-15T22:47:36Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-15T02:56:08Z, latest 2026-10-15T22:47:36Z).
The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_self_deploy_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.060287s, giveups=1, steals=0 (max 3/window), wait floor=60s.
