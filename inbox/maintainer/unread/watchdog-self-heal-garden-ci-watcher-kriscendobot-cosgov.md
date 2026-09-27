from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:57:14Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-cosgov
notice_count: 3
first_seen: 2026-09-27T01:56:24Z
last_seen: 2026-09-27T04:57:14Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-27T01:56:24Z, latest 2026-09-27T04:57:14Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-cosgov`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-cosgov exited rc=1 with no scoped fix. Capture: 0a93c44537a7f567c046474fcc82c5b1440031c5 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0a93c44537a7f567c046474fcc82c5b1440031c5). Diagnosis: **No JOB block.** `garden-ci-watcher@kriscendobot-cosgov` FATAL'd with `cannot acquire clone lock .../verify.lock after 3 waits of 60s and 0 reclaim attempt(s)`. This matches a known, already-fixed defect (`5620bdbe5f6` isolate CI-watcher clones per slug; `e6ea1d33fc8` skip quietly on live-holder contention), plus follow-on hardening — all present on `origin/main2` but not yet reachable from the deployed root checkout (`HEAD` = `47b41af5a14`, 19 commits behind `origin/main2`). This is deploy lag, not a code gap: the rolling-deploy pipeline hasn't advanced this host past the fix yet. No action needed beyond letting the deliberate deploy catch up; memory entry updated to record the recurrence.
