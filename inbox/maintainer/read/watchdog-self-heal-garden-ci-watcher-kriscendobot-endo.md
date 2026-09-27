from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T02:27:17Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo
notice_count: 1
first_seen: 2026-09-27T02:27:17Z
last_seen: 2026-09-27T02:27:17Z
---
self-heal: garden-ci-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: f5d9848189d089e850d24648be4d9a7cd401f1f5 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f5d9848189d089e850d24648be4d9a7cd401f1f5). Diagnosis: This is the exact known issue from memory: **ci-watcher shared verify clone-lock contention**, already fixed upstream by commits `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention), both dated 2026-09-27. The deployed root checkout (`HEAD` = `47b41af5a14`, 2026-09-26) is a confirmed ancestor of both fix commits — this is pure deploy lag, not a new defect. No fix job needed.

The `garden-ci-watcher@kriscendobot-endo` failure is the already-fixed shared-clone-lock contention bug: the CI watcher for the `kriscendobot/endo` repo timed out waiting on `/home/kris/garden/.garden-state/ci-watcher/verify.lock`, held busy by a peer watcher, and gave up after 3×60s backoffs. Commits `5620bdbe5f6` and `e6ea1d33fc8` (landed on `origin/main2` 
