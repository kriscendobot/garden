from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-29T11:28:13Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_monitors_monk_1_journal
notice_count: 2
first_seen: 2026-10-23T13:16:23Z
last_seen: 2026-10-29T11:28:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-23T13:16:23Z, latest 2026-10-29T11:28:13Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_monitors_monk_1_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/monk-1/journal: p95=1.937009s max=32.071932s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
