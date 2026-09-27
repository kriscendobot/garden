from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T02:48:20Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-vattr97
notice_count: 1
first_seen: 2026-09-27T02:48:19Z
last_seen: 2026-09-27T02:48:20Z
---
self-heal: garden-ci-watcher@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: b92ddb7ddb7111e07277976ccbdf031270ac5001 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b92ddb7ddb7111e07277976ccbdf031270ac5001). Diagnosis: This is the already-diagnosed and already-fixed **ci-watcher shared VERIFY clone-lock contention** bug (per prior memory `ci-watcher-clonelock-contention-fixed`), and the failure signature confirms it exactly: `garden-ci-watcher@kriscendobot-vattr97` hit `FATAL: cannot acquire clone lock /home/kris/garden/.garden-state/ci-watcher/verify.lock after 3 waits of 60s` — multiple ci-watcher instances (one per repo/slug) were contending on one shared `verify.lock` because clones weren't isolated per slug. That was fixed upstream on `main2` by `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention"), both landed 2026-09-27.

I checked deploy-lag before considering a new fix job: this host's deployed root checkout (`HEAD` = `47b4
