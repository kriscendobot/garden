from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:19:00Z
watchdog_key: journal-contention-storm-fetch-drift
notice_count: 1
first_seen: 2026-11-04T11:19:00Z
last_seen: 2026-11-04T11:19:00Z
---
Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-drift in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: oldest-third median=2.297421s newest-third median=11.501342s over 18106s/13 samples; floor=10s, 1.5x rise or projected-to-guard=39341s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: oldest-third median=1.781512s newest-third median=11.385317s over 19798s/16 samples; floor=10s, 1.5x rise or projected-to-guard=41466s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: oldest-third median=2.306537s newest-third median=11.415738s over 14086s/13 samples; floor=10s, 1.5x rise or projected-to-guard=31057s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/cleric-1/journal: oldest-third median=6.215668s newest-third median=10.048685s over 6110s/256 samples; floor=10s, 1.5x rise or projected-to-guard=34194s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: oldest-third median=6.008378s newest-third median=10.136204s over 4261s/256 samples; floor=10s, 1.5x rise or projected-to-guard=22053s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for _home_kris_garden_journal: oldest-third median=1.802608s newest-third median=13.871829s over 21608s/19 samples; floor=10s, 1.5x rise or projected-to-guard=31560s within 86400s.
