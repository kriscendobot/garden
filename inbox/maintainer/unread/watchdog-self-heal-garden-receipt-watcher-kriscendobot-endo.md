from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T02:04:15Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-endo
notice_count: 1
first_seen: 2026-09-22T02:04:13Z
last_seen: 2026-09-22T02:04:15Z
---
self-heal: garden-receipt-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 44cd0c8f88bfe414d453f6c639abe7b1c209f52e (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 44cd0c8f88bfe414d453f6c639abe7b1c209f52e). Diagnosis: ## Diagnosis

`garden-receipt-watcher@kriscendobot-endo` died via `receipt-watcher.sh`'s own `die()` at line 91:

```
FATAL: receipt journal prerequisite failed for kriscendobot/endo (rc=1; see prerequisite stderr above)
```

The captured blob is exactly that one line — the referenced "prerequisite stderr above" is empty. That's the known bug where a command inside `( ensure_clone "$DIR"; sync_clone "$DIR" )` fails with `prereq_rc=1` without ever routing through `die()`/`log()` (which are the only things that write to that subshell's stderr), so nothing is captured to diagnose.

This is not a new bug — it's the identical signature already caught and fixed today:

- **Commit `3002969de5`** (`fix(receipt-watcher): capture failing prereq command via ERR trap`), authored 41 minutes ago in 
