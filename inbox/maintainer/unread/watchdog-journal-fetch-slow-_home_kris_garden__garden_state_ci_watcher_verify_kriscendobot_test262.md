from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T16:35:18Z
watchdog_key: journal-fetch-slow-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_test262
notice_count: 2
first_seen: 2026-10-28T09:11:55Z
last_seen: 2026-10-28T16:35:18Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-28T09:11:55Z, latest 2026-10-28T16:35:18Z).
The SAME condition (`journal-fetch-slow-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_test262`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-test262: p95=22.779109s max=45.001662s; hard guard=31.500000s (70% of 45s cap); remedy=deferred-deadline.
