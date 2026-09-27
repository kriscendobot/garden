from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:16:00Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-proposal-compartments
notice_count: 2
first_seen: 2026-09-27T02:07:45Z
last_seen: 2026-09-27T04:16:00Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:07:45Z, latest 2026-09-27T04:16:00Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-proposal-compartments`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-proposal-compartments exited rc=1 with no scoped fix. Capture: 517802b82a856b0224a0d0640609fde03195dda0 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 517802b82a856b0224a0d0640609fde03195dda0). Diagnosis: This is the already-fixed shared-clone-lock-contention bug tracked in memory (`ci-watcher-clonelock-clone-lock-contention-fixed`): `garden-ci-watcher@kriscendobot-proposal-compartments` hit `FATAL: cannot acquire clone lock .../ci-watcher/verify.lock` after three 60s backoff retries, the exact signature of the shared-VERIFY-clone contention bug that commits `5620bdbe5f6` ("isolate CI watcher clones per slug") and `e6ea1d33fc8` ("skip quietly on live-holder clone-lock contention") already fixed. Both commits landed on `origin/main2` at 2026-09-27T00:01Z, but this host's deployed root checkout is still pinned at `47b41af5a14` (2026-09-26T12:42Z) — a deploy-lag gap, not a live bug. No new fix job is warranted; the rolling deploy will pick up the fix once it advances this host past `5620bdbe
