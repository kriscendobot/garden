from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:29:16Z
watchdog_key: journal-contention-storm-fetch-drift
notice_count: 2
first_seen: 2026-11-04T11:19:00Z
last_seen: 2026-11-04T11:29:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T11:19:00Z, latest 2026-11-04T11:29:16Z).
The SAME condition (`journal-contention-storm-fetch-drift`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit fetch-drift in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: oldest-third median=2.297421s newest-third median=11.501342s over 18106s/13 samples; floor=10s, 1.5x rise or projected-to-guard=39341s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: oldest-third median=1.781512s newest-third median=11.385317s over 19798s/16 samples; floor=10s, 1.5x rise or projected-to-guard=41466s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: oldest-third median=1.568251s newest-third median=10.268896s over 9057s/256 samples; floor=10s, 1.5x rise or projected-to-guard=22101s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-oros-ckm-data-readiness: oldest-third median=2.306537s newest-third median=11.415738s over 14086s/13 samples; floor=10s, 1.5x rise or projected-to-guard=31057s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: oldest-third median=6.316391s newest-third median=10.467697s over 6023s/120 samples; floor=10s, 1.5x rise or projected-to-guard=30515s within 86400s.
- Journal fetch drift on endolin-garden-ece02cb4 for _home_kris_garden_journal: oldest-third median=1.727386s newest-third median=13.877769s over 19838s/20 samples; floor=10s, 1.5x rise or projected-to-guard=28772s within 86400s.
