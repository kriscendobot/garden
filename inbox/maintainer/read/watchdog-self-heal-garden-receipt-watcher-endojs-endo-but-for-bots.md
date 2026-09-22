from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:58:20Z
watchdog_key: self-heal-garden-receipt-watcher-endojs-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-22T06:58:16Z
last_seen: 2026-09-22T06:58:20Z
---
self-heal: garden-receipt-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: 89c35ed173f59a3c8c665ad2124aac9145869a3a (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 89c35ed173f59a3c8c665ad2124aac9145869a3a). Diagnosis: This failure is the known, already-fixed `clone_lock` permanent-stderr-silencing bug: `garden-receipt-watcher@endojs-endo-but-for-bots` emits a single empty-context `FATAL: receipt journal prerequisite failed ... (rc=1; see prerequisite stderr above)` line with no diagnostic actually above it — the exact signature caused by `clone_lock`'s flock-timeout retry branch doing `exec {fd}>&- 2>/dev/null || true`, which permanently silences the (sub)shell's stderr so every subsequent `log`/`die` in `ensure_clone`/`sync_clone` writes to nowhere. This was already fixed upstream in commit `06690f63fa` ("fix(receipt-watcher): guard empty prereq stderr + fix perm-silencing exec in clone_lock"), landed on `main2` at 2026-09-22T00:35:39Z. I checked this host's deployed root: HEAD is `917115c9b7` (2026-
