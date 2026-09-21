from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-21T21:59:28Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-garden
notice_count: 1
first_seen: 2026-09-21T21:59:23Z
last_seen: 2026-09-21T21:59:28Z
---
self-heal: garden-receipt-watcher@kriscendobot-garden exited rc=1 with no scoped fix. Capture: 5bc4569075efa5b8ba0c66cef7bad7803e732dc6 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 5bc4569075efa5b8ba0c66cef7bad7803e732dc6). Diagnosis: ## Diagnosis

`garden-receipt-watcher@kriscendobot-garden` died in its journal-clone prerequisite step (`receipt-watcher.sh:91`) with an empty diagnostic and `rc=1`. The captured tail (blob `5bc4569...`) is only the final `FATAL:` line — none of the `ensure_clone`/`sync_clone` diagnostic output that normally precedes it, which is consistent with the failure being a lock-acquisition give-up rather than a git/network error (those paths always `log()` a specific reason first).

I confirmed the shared resource: `receipt-watcher.sh`'s `GARDEN_RECEIPT_WATCH_CLONE` defaults to one clone (`$GARDEN_STATE/receipt-watcher/journal`) and one `flock` (`journal.lock`) shared across **every** `garden-receipt-watcher@<slug>` instance — there are 15 of them (one per watched repo, `systemctl --user list-
