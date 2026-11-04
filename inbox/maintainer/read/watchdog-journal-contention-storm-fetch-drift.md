from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:00:38Z
watchdog_key: journal-contention-storm-fetch-drift
notice_count: 1
first_seen: 2026-11-04T11:00:38Z
last_seen: 2026-11-04T11:00:38Z
---
Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-drift in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: oldest-third median=2.297421s newest-third median=11.501342s over 18106s/13 samples; floor=10s, 1.5x rise or projected-to-guard=39341s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: oldest-third median=1.914043s newest-third median=11.385317s over 19825s/16 samples; floor=10s, 1.5x rise or projected-to-guard=42103s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: oldest-third median=2.306537s newest-third median=11.415738s over 14086s/13 samples; floor=10s, 1.5x rise or projected-to-guard=31057s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/cleric-1/journal: oldest-third median=1.377387s newest-third median=11.181882s over 6003s/256 samples; floor=10s, 1.5x rise or projected-to-guard=12440s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/monitors/monk-1/journal: oldest-third median=1.240534s newest-third median=11.131630s over 6128s/256 samples; floor=10s, 1.5x rise or projected-to-guard=12619s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for _home_kris_garden_journal: oldest-third median=1.802608s newest-third median=13.863375s over 19842s/18 samples; floor=10s, 1.5x rise or projected-to-guard=29015s within 86400s.
