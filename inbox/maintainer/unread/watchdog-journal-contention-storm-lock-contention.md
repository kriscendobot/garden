from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-28T12:24:48Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 197
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-28T12:24:48Z
---
WATCHDOG notice — occurrence #197 (first seen 2026-10-16T17:37:14Z, latest 2026-10-28T12:24:48Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 197 times; this is ONE
coalesced notice that updates in place, not 197 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 8 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.036726s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=0.037167s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.034823s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.037473s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.036134s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.027133s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.030244s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.033939s, giveups=1, steals=0 (max 3/window), wait floor=60s.
