from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T15:34:51Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_leader_journal
notice_count: 4
first_seen: 2026-10-18T11:52:37Z
last_seen: 2026-10-30T15:34:51Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-18T11:52:37Z, latest 2026-10-30T15:34:51Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_leader_journal`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: p95=7.332924s max=32.621371s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
