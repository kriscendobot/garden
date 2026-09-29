from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:58:24Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo
notice_count: 8
first_seen: 2026-09-27T02:27:17Z
last_seen: 2026-09-27T07:58:24Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T02:27:17Z, latest 2026-09-27T07:58:24Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: a98739cb6578cb69d8b8f59ab0fc135c7744434c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a98739cb6578cb69d8b8f59ab0fc135c7744434c). Diagnosis: This is exactly the known deploy-lag situation from memory: `ci-watcher-clone-lock-contention-fix-queued-not-deployed.md`. The root checkout's HEAD (`47b41af5a14`) is ~28 commits behind `origin/main2`, and both known fix commits (`5620bdbe5f6` "isolate CI watcher clones per slug" and `e6ea1d33fc8` "skip quietly on live-holder clone-lock contention") are **not yet ancestors of HEAD** — they're queued upstream but not deployed to this root checkout yet.

The failure signature matches that already-fixed bug exactly: `ci-watcher@kriscendobot-endo` FATAL after 3×60s waits on `.garden-state/ci-watcher/verify.lock`, contending with another watcher instance sharing the same VERIFY clone. No new code fix is needed — posting another `self-heal-fix` job would just duplicate work already merged u
