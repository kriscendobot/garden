from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T01:56:23Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-list
notice_count: 1
first_seen: 2026-09-27T01:56:23Z
last_seen: 2026-09-27T01:56:23Z
---
self-heal: garden-ci-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: e5c318a27a49bb0c888e663bda1192818f1d2110 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e5c318a27a49bb0c888e663bda1192818f1d2110). Diagnosis: Diagnosis: this is legitimate, transient lock contention, not a code defect.

The failing instance (`ci-watcher@kriscendobot-list`) shares one journal-verify clone (`GARDEN_CI_VERIFY_CLONE`, lock file `.garden-state/ci-watcher/verify.lock`) across all ~15 per-repo `ci-watcher@` template instances. At the time of failure, the lock was held by a *live* sibling process (pid 2053714, `ci-watcher.sh kriscendobot-proposal-compartments`, confirmed alive via `kill -0`, ~2m38s into its run) that was performing a full reclone of the VERIFY clone (`verify.reclone.2053714.1/` is an in-progress git clone; an older `verify.contention-old.20260923T194136Z/` shows this clone has needed reclones before). `clone_lock`'s bounded wait ladder (3×60s) correctly refused to steal from that live holder — the co
