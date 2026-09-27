from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:15:22Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-e2e
notice_count: 2
first_seen: 2026-09-27T02:28:08Z
last_seen: 2026-09-27T04:15:22Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:28:08Z, latest 2026-09-27T04:15:22Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-e2e`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: a8e3c4d661301dfde1613071e6d492adcc7cfdbf (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a8e3c4d661301dfde1613071e6d492adcc7cfdbf). Diagnosis: This is the already-fixed shared-VERIFY-clone-lock contention bug (memory: `ci-watcher-clonelock-shared-verify-fixed`), not a new defect. The failure signature matches exactly: `garden-ci-watcher@kriscendobot-ymax-e2e` FATAL after 3 backoff waits on `.garden-state/ci-watcher/verify.lock`. The fix (5620bdbe5f6 "isolate CI watcher clones per slug" + e6ea1d33fc8 "skip quietly on live-holder clone-lock contention") is confirmed present on `origin/main2` but the deployed root checkout (`HEAD`) is a clean fast-forward ancestor 19 commits behind — ordinary deploy lag, not a divergence or revert. No new fix job is warranted; the root will self-resolve once the next deliberate deploy lands. No JOB block.
