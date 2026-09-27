from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:48:06Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-vattr97
notice_count: 6
first_seen: 2026-09-27T02:48:19Z
last_seen: 2026-09-27T06:48:06Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:48:19Z, latest 2026-09-27T06:48:06Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-vattr97`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: e3ebe36ec0dab91aa167d2b49c6af1fcfd34bd80 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e3ebe36ec0dab91aa167d2b49c6af1fcfd34bd80). Diagnosis: Confirmed: this is the exact known deploy-lag recurrence already tracked in memory (`ci-watcher-clone-lock-contention-fix-queued-not-deployed`) — same signature previously seen for this very instance (`kriscendobot-vattr97`), same 19-commit gap to `origin/main2` at `586aee8196b4`, with the fix commits `5620bdbe5f6`/`e6ea1d33fc8` and follow-ons still not an ancestor of the deployed root HEAD `47b41af5a14`.

No new code defect — the fix is already merged to `main2` but hasn't rolled out to this root checkout yet via the deliberate rolling deploy. Per the memory's guidance, I'm emitting no JOB block; this would just rediscover an already-landed fix. Once the rolling deploy advances this host past `586aee8196b4`, the failure should stop recurring — worth checking `garden-rolling-deploy` 
