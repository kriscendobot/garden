from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:57:49Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-ymax-e2e
notice_count: 1
first_seen: 2026-09-22T06:57:47Z
last_seen: 2026-09-22T06:57:49Z
---
self-heal: garden-receipt-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: d13120e4778cc3dfe36ed8c2f0ba7f6be14497a9 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d13120e4778cc3dfe36ed8c2f0ba7f6be14497a9). Diagnosis: This is the known, already-fixed `clone_lock` stderr-silencing bug (memory: `receipt-watcher-clonelock-stderr-deploy-lag`). The capture blob is exactly the single-line empty-context signature:

```
FATAL: receipt journal prerequisite failed for kriscendobot/ymax-e2e (rc=1; see prerequisite stderr above)
```

with nothing above it — matching the pattern caused by the `exec {fd}>&- 2>/dev/null || true` permanent-stderr-silencing bug in `clone_lock` (`scripts/jobs/common.sh`).

The fix (commit `06690f63fa`, "fix(receipt-watcher): guard empty prereq stderr + fix perm-silencing exec in clone_lock") is **not yet an ancestor of the current root HEAD** (`917115c9b7`, 2 days old vs. the fix landed 6 hours ago) — this is deploy lag, not a fresh bug. Per the memory, posting another `self-heal-fix
