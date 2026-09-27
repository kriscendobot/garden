from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T01:56:29Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-cosgov
notice_count: 1
first_seen: 2026-09-27T01:56:24Z
last_seen: 2026-09-27T01:56:29Z
---
self-heal: garden-ci-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 5182d93e1cf5d1fa6b9c17a34d83154b4e94f39a (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 5182d93e1cf5d1fa6b9c17a34d83154b4e94f39a). Diagnosis: Confirmed: this is deploy-lag, not a new bug. The fix (`5620bdbe5f6` "fix: isolate CI watcher clones per slug", plus the follow-up `4948cdd9a75` holding clone_lock across verify_fetch, and today's regression test `02adfdaf324`) already landed upstream and is an ancestor of `origin/main2` — but the deployed root here (`HEAD=47b41af5a14`) is behind it, and `HEAD` is confirmed as an ancestor of the fix commit.

Journal history for this exact signature is extensive: `self-heal-fix-garden-ci-watcher-kriscendobot-cosgov-shared-clone-lock-contention` and the generic `self-heal-fix-garden-ci-watcher-shared-verify-clone-lock-contention` were already posted, claimed, and marked `tada` (done) — this is the same root cause (all per-repo `ci-watcher@<slug>` instances sharing one `$GARDEN_STATE/ci-w
