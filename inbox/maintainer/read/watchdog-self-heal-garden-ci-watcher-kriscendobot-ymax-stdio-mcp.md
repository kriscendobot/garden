from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T03:51:58Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp
notice_count: 4
first_seen: 2026-09-27T02:00:56Z
last_seen: 2026-09-27T03:51:58Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:00:56Z, latest 2026-09-27T03:51:58Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-stdio-mcp exited rc=1 with no scoped fix. Capture: 36d513a86115823f4b185117ac62e992bff66c31 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 36d513a86115823f4b185117ac62e992bff66c31). Diagnosis: This memory already fully covers this exact recurrence (repo slug `kriscendobot-ymax-stdio-mcp`) — no update needed, the existing entry already prescribes exactly the check I just ran and the "don't post a job" outcome. No further action required beyond the report above.

**Summary:** Diagnosed `garden-ci-watcher@kriscendobot-ymax-stdio-mcp`'s exit 1 as the known shared-VERIFY-clone-lock contention bug, already fixed on `main2` (commits `5620bdbe5f6`, `e6ea1d33fc8`) but not yet deployed to this host's checkout (19 commits behind `origin/main2`). No JOB posted — this is deploy-lag, and systemd's restart will succeed once the pending rolling-deploy lands the fix.
