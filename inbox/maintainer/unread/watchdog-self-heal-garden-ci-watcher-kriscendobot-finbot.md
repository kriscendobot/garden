from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:03:18Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-finbot
notice_count: 4
first_seen: 2026-09-27T02:28:18Z
last_seen: 2026-09-27T06:03:18Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:28:18Z, latest 2026-09-27T06:03:18Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-finbot`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 74d9297b9802f628a891bfbddb06d3ec5c9bb6be (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 74d9297b9802f628a891bfbddb06d3ec5c9bb6be). Diagnosis: This failure is deploy lag, not a new defect. The root checkout is pinned at `47b41af5a14` (2026-09-26T12:42Z), but the clone-lock contention fix (`5620bdbe5f6` "isolate CI watcher clones per slug" + `e6ea1d33fc8` "skip quietly on live-holder clone-lock contention") plus several follow-on hardening commits already landed on `origin/main2` (now at `586aee8196b4`, 2026-09-27T03:28Z) — the deployed root just hasn't rolled forward yet. This is the same recurring deploy-lag pattern already tracked in memory ([[ci-watcher-clone-lock-contention-fix-queued-not-deployed]]), now confirmed for a fourth watcher instance (`kriscendobot-finbot`), and I've updated that memory with this occurrence.

No JOB block — posting a fix would be redundant since the fix is already merged and only awaiting the r
