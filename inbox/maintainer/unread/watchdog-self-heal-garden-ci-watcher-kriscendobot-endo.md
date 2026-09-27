from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:03:13Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo
notice_count: 2
first_seen: 2026-09-27T02:27:17Z
last_seen: 2026-09-27T04:03:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:27:17Z, latest 2026-09-27T04:03:13Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: b5c9a20dd04b05189440b6464b1d617fab7f00d0 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p b5c9a20dd04b05189440b6464b1d617fab7f00d0). Diagnosis: This is deploy-lag, not a code defect that needs a new job.

The failure is the ci-watcher's shared `verify.lock` clone-lock contention — the exact signature already fixed on `main2` earlier today (2026-09-27 00:01 UTC) by commits `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention"), per [[ci-watcher-shared-verify-clone-lock-contention-fixed]]. This host's deployed root checkout (HEAD `47b41af5a14`, from 2026-09-26 12:42 UTC) predates that fix and is currently 19 commits behind `main2` (`upgrade-ready` marker detected 2026-09-27T04:02:01Z, available `586aee8196b`). Posting another `self-heal-fix-*` job would be redundant — the fix already exists upstream, waiting only for the next deploy to land. No JOB block.
