from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T05:19:13Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-list
notice_count: 2
first_seen: 2026-09-22T01:17:55Z
last_seen: 2026-09-22T05:19:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-22T01:17:55Z, latest 2026-09-22T05:19:13Z).
The SAME condition (`self-heal-garden-receipt-watcher-kriscendobot-list`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-receipt-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: 1c25795830cc82dd7d0cf7b00f0bb7468d395466 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 1c25795830cc82dd7d0cf7b00f0bb7468d395466). Diagnosis: Confirmed: this is pure deploy lag, not a missing fix. The root cause was already diagnosed and fixed on `main2` in commit `06690f63fa` five hours ago (`clone_lock`'s flock-timeout branch ran `exec {fd}>&- 2>/dev/null`, which — since `exec` with only redirections applies them permanently — silenced the subshell's stderr for the rest of the run, so the later `die()`/log lines on the lock-contention path wrote to nowhere). This host's deployed root checkout (`917115c9b7`) is 37 commits behind `origin/main2` and hasn't picked up that fix yet. No new fix is needed — this is the identical, already-fixed signature seen in the `kriscendobot-endo`, `kriscendobot-finbot`, and `kriscendobot-proposal-compartments` incidents in the maintainer inbox.

I'll write the one-paragraph explanation and 
