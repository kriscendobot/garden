from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T03:10:42Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-27T03:10:42Z
last_seen: 2026-09-27T03:10:42Z
---
self-heal: garden-ci-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: a0ed758f63a92e6dbce0be5d272bc49b56985fcd (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a0ed758f63a92e6dbce0be5d272bc49b56985fcd). Diagnosis: Confirmed: this is deploy lag, not a new bug. `origin/main2` already contains the fix commits (`5620bdbe5f6` + `e6ea1d33fc8`, landed 2026-09-27), but this host's deployed root checkout is still pinned at `47b41af` (2026-09-26), one commit before the fix. The failure signature is character-for-character the already-remediated shared-clone-lock contention bug — the ci-watcher for `kriscendobot-endo-but-for-bots` was racing another verify-clone holder on the pre-fix shared lock path and timed out after 3×60s backoffs.

No new fix job needed. This will self-resolve once the leader's rolling deploy advances the root checkout past `e6ea1d33fc8` (the fleet's normal deliberate-deploy cadence handles this — no code defect to post). Systemd's restart is sufficient in the interim; a fresh occurr
