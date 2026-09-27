from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:25:11Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 1
first_seen: 2026-09-27T03:10:57Z
last_seen: 2026-09-27T04:25:11Z
---
self-heal: garden-ci-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: fbe65e301758ac1a968856b085c3d26da2b8c8da (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p fbe65e301758ac1a968856b085c3d26da2b8c8da). Diagnosis: This is confirmed deploy-lag, exactly matching the known, already-fixed issue in memory ([[ci-watcher-shared-verify-clone-lock-contention-fixed]]).

**Diagnosis:** `garden-ci-watcher@kriscendobot-oros-ckm-data-readiness` hit the shared `VERIFY`-clone lock contention bug — every ci-watcher instance fleet-wide shared one clone (`$GARDEN_STATE/ci-watcher/verify`) and lock, so a long-running clone for one repo starved another repo's ticks past their 3×60s patience, producing a loud FATAL exit instead of a quiet skip. This was already fixed on `main2` on 2026-09-27 via two layered commits: `5620bdbe5f6` (isolates the clone per repo slug, eliminating the shared lock) and `e6ea1d33fc8` (makes residual contention exit quietly as an outage instead of FATAL-looping).

I verified: both fix commits
