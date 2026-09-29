from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:57:55Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-minion-town
notice_count: 8
first_seen: 2026-09-27T01:58:17Z
last_seen: 2026-09-27T07:57:55Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T01:58:17Z, latest 2026-09-27T07:57:55Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-minion-town`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 3456960e3dd295571e45ddb0fb3ad085dc410085 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 3456960e3dd295571e45ddb0fb3ad085dc410085). Diagnosis: Confirmed: this is exactly the deploy-lag pattern in my memory (ci-watcher-clone-lock-contention-fix-queued-not-deployed). The running root checkout's HEAD (`47b41af5a14`) is 29 commits behind `origin/main2`, and both fix commits for this exact FATAL (`5620bdbe5f6` "isolate CI watcher clones per slug" and `e6ea1d33fc8` "skip quietly on live-holder clone-lock contention") are already merged upstream but not yet deployed to this host's root checkout. There's no new code defect here — the deploy just needs to catch up.

This is transient/environmental (deploy-lag), not a fresh code defect, so no JOB block.

The `garden-ci-watcher@kriscendobot-minion.town` FATAL (clone-lock busy after 3 retries) is the already-fixed shared-verify-clone-lock contention bug. Commits `5620bdbe5f6` and `e6ea1d33
