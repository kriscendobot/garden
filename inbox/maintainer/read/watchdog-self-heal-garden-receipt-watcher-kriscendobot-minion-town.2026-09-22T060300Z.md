from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:03:00Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-minion-town
notice_count: 1
first_seen: 2026-09-22T02:12:06Z
last_seen: 2026-09-22T06:03:00Z
---
self-heal: garden-receipt-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 6c06d5a1f304dca3d7725fa53146fed4edaa5712 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 6c06d5a1f304dca3d7725fa53146fed4edaa5712). Diagnosis: This is confirmed as pure deploy lag, not a new bug. This exact failure signature — empty `$PREREQ_ERR`, single "FATAL: receipt journal prerequisite failed" line — was already root-caused and fixed on `main2` five hours ago:

- **`06690f63fa`** — fixed the actual root cause: `clone_lock`'s flock-timeout branch ran `exec {fd}>&- 2>/dev/null`, and since `exec` with only redirections applies them *permanently*, this silenced the subshell's stderr for the rest of the run, so the `die()`/`log()` calls on the lock-contention path (very plausible here given many receipt-watcher instances share the same unsuffixed clone directory `$GARDEN_STATE/receipt-watcher/journal` and contend for its `clone_lock`) wrote to nowhere. Also added a fallback diagnostic line for when `$PREREQ_ERR` is genuinel
