from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T04:44:54Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-endo
notice_count: 1
first_seen: 2026-09-22T02:04:13Z
last_seen: 2026-09-22T04:44:54Z
---
self-heal: garden-receipt-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 458a01829296c171b6cb76fb9ec7d68d9e844fae (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 458a01829296c171b6cb76fb9ec7d68d9e844fae). Diagnosis: ## Diagnosis

The failure line (`FATAL: receipt journal prerequisite failed for kriscendobot/endo (rc=1; see prerequisite stderr above)`) is genuinely all the output the run produced — the referenced "prerequisite stderr above" was empty, because this host's deployed root checkout is running the **pre-hardening** `receipt-watcher.sh` (`git -C /home/kris/garden rev-parse HEAD` → `917115c9b7`, dated 2026-09-19). That version still has the old blind `sed .../die "see prerequisite stderr above"` path with no `[ -s "$PREREQ_ERR" ]` split and no ERR trap.

This is not a new bug. `journal/jobs/tada/2026/09/22/` already shows **11 receipt-watcher self-heal-fix jobs landed on `main2` today**, all in this exact failure family (shared-clone lock contention, silent/empty `$PREREQ_ERR`, sync_clone 
