from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:31:48Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp
notice_count: 4
first_seen: 2026-09-27T02:00:56Z
last_seen: 2026-09-27T06:31:48Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:00:56Z, latest 2026-09-27T06:31:48Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-stdio-mcp exited rc=1 with no scoped fix. Capture: ca5d3f7c701740b15367c3f79f5d5bd7695d7fa1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ca5d3f7c701740b15367c3f79f5d5bd7695d7fa1). Diagnosis: This confirms the deploy-lag scenario is expected/self-resolving infra, not something requiring a fix job. Per the existing memory, this is a known pattern.

No job needed. This is the already-diagnosed shared-clone-lock contention bug (`/home/kris/garden/.garden-state/ci-watcher/verify.lock`), fixed on `origin/main2` via commits `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention") landed 2026-09-27T00:01Z. This host's root checkout (`HEAD` 47b41af5a14, dated 2026-09-26) is 19 commits behind `origin/main2` and simply hasn't picked up the fix via the deliberate rolling deploy yet. The autonomous `garden-self-deploy`/rolling-deploy machinery should pick this up on its own upgrade-ready cycle; no new code change or job is
