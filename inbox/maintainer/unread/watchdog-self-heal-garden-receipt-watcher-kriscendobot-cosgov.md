from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-22T06:57:57Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-cosgov
notice_count: 2
first_seen: 2026-09-22T05:11:58Z
last_seen: 2026-09-22T06:57:57Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-22T05:11:58Z, latest 2026-09-22T06:57:57Z).
The SAME condition (`self-heal-garden-receipt-watcher-kriscendobot-cosgov`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-receipt-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 9e3ee6b2fb40fadd2bb72481dfa845faf9f20c4d (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9e3ee6b2fb40fadd2bb72481dfa845faf9f20c4d). Diagnosis: Diagnosis: this is the known `clone_lock` permanent-stderr-silencing bug in `scripts/jobs/common.sh` (empty-context `FATAL: receipt journal prerequisite failed ... see prerequisite stderr above` with nothing actually above it). It was already fixed on `main2` in commit `06690f63fa` ("fix(receipt-watcher): guard empty prereq stderr + fix perm-silencing exec in clone_lock"), and that commit is present on `origin/main2` — but this host's deployed garden root (`HEAD` at `917115c9b7`) does not yet have it as an ancestor. This is pure deploy lag on `kriscendobot-cosgov`, not a fresh code defect, and will self-resolve once the rolling deploy advances this host past `06690f63fa`. Per prior recorded experience, filing another `self-heal-fix-garden-receipt-watcher-*` job here would just rediscover
