from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:10:08Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-list
notice_count: 2
first_seen: 2026-09-27T01:56:23Z
last_seen: 2026-09-27T04:10:08Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T01:56:23Z, latest 2026-09-27T04:10:08Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-list`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: d9c2b63676b5fcf3429fa7373cc019328ec48cd1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d9c2b63676b5fcf3429fa7373cc019328ec48cd1). Diagnosis: This `garden-ci-watcher@kriscendobot-list` failure is the known shared-VERIFY-clone-lock contention bug: the log shows the classic signature — three 60s backoff retries against `.garden-state/ci-watcher/verify.lock` followed by `FATAL: cannot acquire clone lock ... after 3 waits`. Per memory ([ci-watcher-clonelock-contention-fixed]), this exact failure was already fixed upstream by commits `5620bdbe5f6` (isolate CI-watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention), landed 2026-09-27T00:01Z on `main2`.

Checking this host's deployed root against those commits: HEAD (`47b41af5a14`) is 9 commits behind `e6ea1d33fc8` — the fix hasn't been deployed to this instance yet. This is deploy-lag, not a new defect requiring a fresh fix job. No JOB block.
