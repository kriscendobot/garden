from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:14:07Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-finbot
notice_count: 1
first_seen: 2026-09-22T02:05:06Z
last_seen: 2026-09-22T06:14:07Z
---
self-heal: garden-receipt-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: da0dacd96d453dd34b9d9e98f9eaa17955005862 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p da0dacd96d453dd34b9d9e98f9eaa17955005862). Diagnosis: Diagnosis: this is **deploy lag on an already-fixed bug**, not a new failure.

The capture blob has exactly one line — `FATAL: receipt journal prerequisite failed for kriscendobot/finbot (rc=1; see prerequisite stderr above)` — with nothing actually above it. That's the signature of a known bug in `clone_lock` (`scripts/jobs/common.sh`): its flock-timeout retry branch ran `exec {fd}>&- 2>/dev/null || true`. Since `exec` with only redirections applies them *permanently* to the shell, that `2>/dev/null` silenced the (sub)shell's stderr for the rest of the run, so every subsequent `log`/`die` in `ensure_clone`/`sync_clone` — including receipt-watcher.sh's own prerequisite `die` — wrote to nowhere, leaving `$PREREQ_ERR` empty and the diagnostic blank.

I confirmed this was already fixe
