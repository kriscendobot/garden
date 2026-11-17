from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-17T09:53:31Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 37
first_seen: 2026-11-13T05:48:51Z
last_seen: 2026-11-17T09:53:31Z
---
WATCHDOG notice — occurrence #37 (first seen 2026-11-13T05:48:51Z, latest 2026-11-17T09:53:31Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 37 times; this is ONE
coalesced notice that updates in place, not 37 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.029943s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.028201s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.026206s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.027214s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.032083s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.039281s, giveups=1, steals=0 (max 3/window), wait floor=60s.
