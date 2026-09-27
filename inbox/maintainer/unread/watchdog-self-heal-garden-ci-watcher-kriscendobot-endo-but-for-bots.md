from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:53:11Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo-but-for-bots
notice_count: 4
first_seen: 2026-09-27T03:10:42Z
last_seen: 2026-09-27T05:53:11Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T03:10:42Z, latest 2026-09-27T05:53:11Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo-but-for-bots`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: ba3c7509ba1c61e6a0af35d5f77d211f4183c424 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ba3c7509ba1c61e6a0af35d5f77d211f4183c424). Diagnosis: This confirms the exact known deploy-lag scenario from memory: the FATAL clone-lock-busy error on `garden-ci-watcher@kriscendobot-endo-but-for-bots` is already fixed upstream — `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention), plus a dozen more related fixes, all sit on `origin/main2` but haven't reached the deployed root checkout (`HEAD` is 15 commits behind on exactly this lock-contention code path). This is environmental/deploy-lag, not a new code defect — no job needed; the rolling deploy will pick these commits up when it advances.
