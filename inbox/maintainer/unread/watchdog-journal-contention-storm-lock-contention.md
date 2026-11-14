from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-14T13:55:01Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 24
first_seen: 2026-11-13T05:48:51Z
last_seen: 2026-11-14T13:55:01Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-11-13T05:48:51Z, latest 2026-11-14T13:55:01Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.017290s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.014883s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.017392s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.016216s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/gauntlet/journal: p95=0.016681s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.015307s, giveups=1, steals=0 (max 3/window), wait floor=60s.
