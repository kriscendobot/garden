from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:40:50Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-e2e
notice_count: 6
first_seen: 2026-09-27T02:28:08Z
last_seen: 2026-09-27T06:40:50Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:28:08Z, latest 2026-09-27T06:40:50Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-e2e`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: 159d9e28b3f69b3eb63637eda3dc1b5ab948d4f4 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 159d9e28b3f69b3eb63637eda3dc1b5ab948d4f4). Diagnosis: This is the known deploy-lag scenario: the fix (5620bdbe5f6 + e6ea1d33fc8) is already merged to `origin/main2`, but the deployed root checkout (HEAD) is 19 commits behind and hasn't picked it up yet. This matches memory `ci-watcher-clone-lock-contention-fix-queued-not-deployed` and `ci-watcher-shared-verify-clone-lock-contention-fixed`.

No new fix job needed — this is a deploy-lag artifact of an already-fixed bug, not a fresh defect. Emitting nothing (no JOB block), just a note.

The `garden-ci-watcher@kriscendobot-ymax-e2e` failure is the already-fixed shared-VERIFY-clone-lock contention bug (fixed on `main2` via 5620bdbe5f6 + e6ea1d33fc8, confirmed ancestors of `origin/main2`), but the deployed root checkout at HEAD (47b41af5a14) is 19 commits behind `origin/main2` and hasn't absorbed
