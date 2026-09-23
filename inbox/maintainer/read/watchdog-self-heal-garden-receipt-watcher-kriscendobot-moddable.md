from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:15:03Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-moddable
notice_count: 1
first_seen: 2026-09-22T06:14:56Z
last_seen: 2026-09-22T06:15:03Z
---
self-heal: garden-receipt-watcher@kriscendobot-moddable exited rc=1 with no scoped fix. Capture: a17424e1bc39cd29eedb219d9d3de7fa0d8af09f (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a17424e1bc39cd29eedb219d9d3de7fa0d8af09f). Diagnosis: Confirmed: this is the known `clone_lock` stderr-silencing bug, already fixed on `main2` at `06690f63fa` (2026-09-22 00:35 UTC), but this host's garden root (HEAD `917115c9b7`, 2026-09-19 21:29 UTC) predates that fix — deploy lag, not a new bug.

No JOB block — posting another `self-heal-fix-garden-receipt-watcher-*` job would just rediscover the already-landed fix at real cost, per the recorded incident history (this exact signature has already recurred across finbot, minion-town, cosgov, proposal-compartments, test262, endo-but-for-bots, garden, ymax, and now moddable). This will self-resolve once this host's rolling-deploy cycle advances past `06690f63fa`.
