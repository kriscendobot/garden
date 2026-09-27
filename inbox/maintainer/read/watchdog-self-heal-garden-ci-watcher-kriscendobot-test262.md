from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T03:25:52Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-test262
notice_count: 1
first_seen: 2026-09-27T03:25:52Z
last_seen: 2026-09-27T03:25:52Z
---
self-heal: garden-ci-watcher@kriscendobot-test262 exited rc=1 with no scoped fix. Capture: 54bdbbc998dd4b9537026383f459f5d741015615 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 54bdbbc998dd4b9537026383f459f5d741015615). Diagnosis: Confirmed: this is the same shared clone-lock contention on `garden-ci-watcher@kriscendobot-test262` already recorded in memory ([ci-watcher-clonelock-contention-fixed]) as fixed by `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention"), both landed on `main2` at 2026-09-27T00:01Z. The root checkout here is still deployed at `47b41af5a14` (2026-09-26T12:42Z), an ancestor of both fix commits — so this host simply hasn't rolled the deploy forward yet. No new code fix is needed; the existing fix has not reached this host.

This is a deploy-lag recurrence of an already-fixed bug, not a new defect — no JOB block.
