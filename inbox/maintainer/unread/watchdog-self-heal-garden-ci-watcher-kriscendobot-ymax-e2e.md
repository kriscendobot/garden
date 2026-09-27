from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:19:34Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-e2e
notice_count: 4
first_seen: 2026-09-27T02:28:08Z
last_seen: 2026-09-27T05:19:34Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:28:08Z, latest 2026-09-27T05:19:34Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-e2e`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: 443a42c064464bae2f1d22ad73c481f521280f60 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 443a42c064464bae2f1d22ad73c481f521280f60). Diagnosis: This is the already-fixed shared-VERIFY-clone-lock-contention bug (commits `5620bdbe5f6` "isolate CI watcher clones per slug" + `e6ea1d33fc8` "skip quietly on live-holder clone-lock contention", both landed on `origin/main2` 2026-09-27T00:01Z). The deployed root checkout (`HEAD` = `47b41af5a14`) is 19 commits behind `origin/main2` and predates both fixes — this is pure deploy-lag, not a live code defect. No new fix job needed; the existing fix will resolve this once the rolling deploy advances the root checkout past `main2`'s current tip.
