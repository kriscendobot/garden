from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:43:53Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ocapn
notice_count: 11
first_seen: 2026-09-27T00:00:04Z
last_seen: 2026-09-27T08:43:53Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-09-27T00:00:04Z, latest 2026-09-27T08:43:53Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ocapn`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: f10a2ef0232429e24526f3fed5c3f9db1222d040 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f10a2ef0232429e24526f3fed5c3f9db1222d040). Diagnosis: This is deploy-lag, not a new bug: the deployed root checkout (HEAD) is 36 commits behind `origin/main2`, and the gap contains a whole chain of already-landed fixes for exactly this failure signature (`FATAL: cannot acquire clone lock .../verify.lock` in `garden-ci-watcher`) — including `5620bdbe5f6` (isolate CI watcher clones per slug), `e6ea1d33fc8` (skip quietly on live-holder contention), plus earlier latching/soft-lock fixes (`ab66fece68f`, `1570aa85a47`, `ad55dea66f9`, `4948cdd9a75`, `c38cb55b172`, `5b48813cd0b`, `5b0a95ac0b3`). This matches the recorded pattern in memory (`ci-watcher-clone-lock-contention-fix-queued-not-deployed` / `ci-watcher-shared-verify-clone-lock-contention-fixed`): the code fix already exists upstream and just hasn't reached this deployed checkout yet via th
