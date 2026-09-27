from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:31:23Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-proposal-compartments
notice_count: 4
first_seen: 2026-09-27T02:07:45Z
last_seen: 2026-09-27T05:31:23Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:07:45Z, latest 2026-09-27T05:31:23Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-proposal-compartments`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-proposal-compartments exited rc=1 with no scoped fix. Capture: 92fb9a4dae757cc601db73d40b2b99b3c8fc9f84 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 92fb9a4dae757cc601db73d40b2b99b3c8fc9f84). Diagnosis: This is the same known deploy-lag pattern already recorded in memory (`ci-watcher-clone-lock-contention-fix-queued-not-deployed`), now recurring for `kriscendobot-proposal-compartments`.

**Diagnosis:** `garden-ci-watcher@kriscendobot-proposal-compartments` FATAL'd with "cannot acquire clone lock .../verify.lock after 3 waits of 60s and 0 reclaim attempt(s)". The root checkout HEAD (`47b41af5a14`) is 26 commits behind `origin/main2` (`586aee8196b`), and that gap contains exactly the fix chain for this signature: `5620bdbe5f6` (isolate CI-watcher clones per slug), `e6ea1d33fc8`, `ab66fece68f`, `1570aa85a47`, `4948cdd9a75`, `c38cb55b172`, `ad55dea66f9`, `4692b4df0e7`, and `586aee8196b` (deterministic lock-holder readiness handshake). These are already merged to `main2` but not yet rolled out
