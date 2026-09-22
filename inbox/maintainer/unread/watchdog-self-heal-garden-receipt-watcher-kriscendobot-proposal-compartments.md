from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T01:09:40Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-proposal-compartments
notice_count: 1
first_seen: 2026-09-22T00:05:30Z
last_seen: 2026-09-22T01:09:40Z
---
self-heal: garden-receipt-watcher@kriscendobot-proposal-compartments exited rc=1 with no scoped fix. Capture: 4b2007ce3b11cd4a727a2ab963f7b55836d4a69d (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 4b2007ce3b11cd4a727a2ab963f7b55836d4a69d). Diagnosis: Confirmed all three fixes are real, already merged to `origin/main2`, and this host's deployed root (`917115c9b7`) is 29 commits behind — this is pure deploy lag, not a missing fix.

**Diagnosis:** The receipt-watcher failed with the classic empty-`$PREREQ_ERR` "silent `rc=1`" signature. This exact failure class was already root-caused and fixed on `main2`:

- `06690f63fa` — fixed the actual root cause: `clone_lock`'s flock-timeout branch ran `exec {fd}>&- 2>/dev/null`, which (bash quirk) permanently silenced the subshell's stderr for the rest of the run, so `die()`/`log()` calls on the lock-contention path wrote to nowhere. Also added a fallback diagnostic line for when `$PREREQ_ERR` is genuinely empty.
- `85ae2f878c` — guarded the previously-bare `git reset --hard` retry in `sync_c
