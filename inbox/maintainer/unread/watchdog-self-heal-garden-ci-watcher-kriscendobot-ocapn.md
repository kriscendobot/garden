from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:19:27Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ocapn
notice_count: 5
first_seen: 2026-09-27T00:00:04Z
last_seen: 2026-09-27T05:19:27Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-27T00:00:04Z, latest 2026-09-27T05:19:27Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ocapn`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: abff2f958d310649a52a0454682cbfde8c748799 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p abff2f958d310649a52a0454682cbfde8c748799). Diagnosis: This is the known shared-VERIFY-clone contention bug: `ci-watcher@kriscendobot-ocapn` failed because every `ci-watcher@<repo>` instance shares one `$GARDEN_STATE/ci-watcher/verify.lock`, so a busy sibling repo's watcher can hold the lock long enough that this one times out after 3×60s waits with no live-holder staleness to reclaim. That's already fixed upstream on `main2` — commit `5620bdbe5f6` ("isolate CI watcher clones per slug") plus `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention") — but the deployed root checkout (`HEAD` at `47b41af5a14`) is 19 commits behind `origin/main2` and doesn't include either commit yet. This is a deploy-lag recurrence of an already-solved bug, not a new defect, so I'm not posting a fix job (would be a redundant/duplicate of already-lan
