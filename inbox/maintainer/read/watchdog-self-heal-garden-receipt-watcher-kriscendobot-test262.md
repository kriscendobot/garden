from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:58:19Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-test262
notice_count: 1
first_seen: 2026-09-22T06:58:05Z
last_seen: 2026-09-22T06:58:19Z
---
self-heal: garden-receipt-watcher@kriscendobot-test262 exited rc=1 with no scoped fix. Capture: ea74390c9914f52f0406228ad5eafe285a20f4f2 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ea74390c9914f52f0406228ad5eafe285a20f4f2). Diagnosis: This is deploy lag, not a new bug. The capture blob contains exactly one line:

```
FATAL: receipt journal prerequisite failed for kriscendobot/test262 (rc=1; see prerequisite stderr above)
```

with no actual prerequisite stderr above it — the signature of the known `clone_lock` permanent-stderr-silencing bug (an `exec {fd}>&- 2>/dev/null` on the flock-timeout retry branch permanently redirected the subshell's stderr to `/dev/null`, blanking every subsequent `log`/`die` including the prerequisite die itself). This was already fixed on `main2` in commit `06690f63fa` ("fix(receipt-watcher): guard empty prereq stderr + fix perm-silencing exec in clone_lock"), which also adds a "(no diagnostic captured...)" fallback for the residual empty case.

I checked ancestry: this host's root checkout
