from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T14:47:15Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_leader_journal
notice_count: 2
first_seen: 2026-10-18T11:52:37Z
last_seen: 2026-10-28T14:47:15Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T11:52:37Z, latest 2026-10-28T14:47:15Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_leader_journal`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=2.533643s max=35.920869s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
