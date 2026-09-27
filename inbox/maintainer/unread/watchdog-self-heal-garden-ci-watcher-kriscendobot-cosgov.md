from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:01:58Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-cosgov
notice_count: 5
first_seen: 2026-09-27T01:56:24Z
last_seen: 2026-09-27T06:01:58Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-27T01:56:24Z, latest 2026-09-27T06:01:58Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-cosgov`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 558e1a04151a7e04c79ab192de72869fba682ee2 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 558e1a04151a7e04c79ab192de72869fba682ee2). Diagnosis: This is a known, already-fixed issue that hasn't been deployed to this host yet — not a new defect.

The blob shows `garden-ci-watcher@kriscendobot-cosgov` hitting the exact FATAL clone-lock-contention crash on `/home/kris/garden/.garden-state/ci-watcher/verify.lock` documented in my prior memory (`ci-watcher-clonelock-stderr-deploy-lag` and `ci-watcher-clone-lock-contention-fix-queued-not-deployed`). Checking the root checkout confirms deploy lag: `origin/main2` is 19 commits ahead of `HEAD` (`47b41af5a14`), and includes exactly the relevant fix chain not yet present locally — `5620bdbe5f6` (isolate CI watcher clones per slug), `e6ea1d33fc8` (skip quietly on live-holder contention), `4948cdd9a75` (hold clone_lock across verify_fetch), `ab66fece68f` (latch busy clone lock contention), 
