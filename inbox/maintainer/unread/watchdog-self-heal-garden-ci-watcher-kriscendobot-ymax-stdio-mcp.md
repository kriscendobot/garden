from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:37:00Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp
notice_count: 6
first_seen: 2026-09-27T02:00:56Z
last_seen: 2026-09-27T07:37:00Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:00:56Z, latest 2026-09-27T07:37:00Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-stdio-mcp exited rc=1 with no scoped fix. Capture: 1d5f80a2df2ecc69c48e8f9a2f1e49d22bf5dd65 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 1d5f80a2df2ecc69c48e8f9a2f1e49d22bf5dd65). Diagnosis: This is the known, already-fixed clone-lock contention bug — not a new defect. The tail shows the exact signature: `ci-watcher/kriscendobot-ymax-stdio-mcp` backed off twice on `/home/kris/garden/.garden-state/ci-watcher/verify.lock` busy >60s, then hit FATAL after 3 waits with no reclaim attempt. That's precisely the failure mode fixed by `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder clone-lock contention), landed on `origin/main2` today (2026-09-27T00:01Z) along with a chain of related clone-lock hardening commits (`c38cb55b172`, `4948cdd9a75`, `9dbda9d5573`, `ad55dea66f9`, `ab66fece68f`, `1570aa85a47`, `4692b4df0e7`). The root checkout this host runs is still pinned at `47b41af5a14` (2026-09-26T12:42Z, the cgroup-sweep commit), which 
