from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:31:53Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ocapn
notice_count: 7
first_seen: 2026-09-27T00:00:04Z
last_seen: 2026-09-27T06:31:53Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T00:00:04Z, latest 2026-09-27T06:31:53Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ocapn`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: 1f3f975f66dfc5ebebf36f85a8671cddf124c629 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 1f3f975f66dfc5ebebf36f85a8671cddf124c629). Diagnosis: Confirmed: this is the known deploy-lag pattern, not a new defect.

The `garden-ci-watcher@kriscendobot-ocapn` failure is the exact `FATAL: cannot acquire clone lock .../ci-watcher/verify.lock ... a live holder is still busy` signature already fixed on `main2` through a chain of commits (`5620bdbe5f6`, `e6ea1d33fc8`, `1570aa85a47`, `ab66fece68f`, `ad55dea66f9`, and follow-ons through `586aee8196b`), per memory `ci-watcher-shared-verify-clone-lock-contention-fixed` and `ci-watcher-clone-lock-contention-fix-queued-not-deployed`. This host's root checkout is still at `47b41af5a14`, 19 commits behind `origin/main2` (`586aee8196b`) — none of the clone-lock fix/latch commits are deployed yet. Once the rolling deploy advances this root past those commits, the outage-latch logic will classify th
