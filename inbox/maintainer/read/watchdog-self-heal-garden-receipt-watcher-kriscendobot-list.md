from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T01:17:56Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-list
notice_count: 1
first_seen: 2026-09-22T01:17:55Z
last_seen: 2026-09-22T01:17:56Z
---
self-heal: garden-receipt-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: b8244a0d7a90e0e45b52426c6bb6082d63087ec1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b8244a0d7a90e0e45b52426c6bb6082d63087ec1). Diagnosis: Deploy infrastructure is running normally (rolling-deploy and upgrade-monitor timers both ticking every few minutes), so this is just normal deploy lag, not a stuck pipeline.

This is a duplicate recurrence of an already-fixed bug that hasn't reached this host's deployed checkout yet, no new fix job needed.

**Diagnosis:** `garden-receipt-watcher@kriscendobot-list` hit `receipt-watcher.sh:91`'s `FATAL: receipt journal prerequisite failed for kriscendobot/list (rc=1; see prerequisite stderr above)` with `PREREQ_ERR` genuinely empty (confirmed via `journalctl` at all priorities, and via `git cat-file` on the capture blob — a single line, no relayed diagnostic). This exact signature — the unguarded second `git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"` retry in `sync_clone()` (`c
