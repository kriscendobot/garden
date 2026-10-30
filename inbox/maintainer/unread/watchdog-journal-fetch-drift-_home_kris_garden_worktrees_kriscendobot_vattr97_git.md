from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-30T09:42:16Z
watchdog_key: journal-fetch-drift-_home_kris_garden_worktrees_kriscendobot_vattr97_git
notice_count: 2
first_seen: 2026-10-30T09:40:18Z
last_seen: 2026-10-30T09:42:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-30T09:40:18Z, latest 2026-10-30T09:42:16Z).
The SAME condition (`journal-fetch-drift-_home_kris_garden_worktrees_kriscendobot_vattr97_git`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal fetch drift on endolin-garden-ece02cb4 for _home_kris_garden_worktrees_kriscendobot_vattr97_git: oldest-third median=1.059738s newest-third median=10.027982s over 19854s/14 samples; floor=10s, 1.5x rise or projected-to-guard=47535s within 86400s.
