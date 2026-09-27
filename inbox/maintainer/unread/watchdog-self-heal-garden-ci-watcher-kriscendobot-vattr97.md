from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:03:13Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-vattr97
notice_count: 2
first_seen: 2026-09-27T02:48:19Z
last_seen: 2026-09-27T04:03:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:48:19Z, latest 2026-09-27T04:03:13Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-vattr97`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-vattr97 exited rc=1 with no scoped fix. Capture: ff9a5254842731bde086b3ebe881a0910ef5ce37 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ff9a5254842731bde086b3ebe881a0910ef5ce37). Diagnosis: The failure is the already-known and already-fixed CI-watcher shared-clone-lock contention: `garden-ci-watcher@kriscendobot-vattr97` timed out 3× waiting on `/home/kris/garden/.garden-state/ci-watcher/verify.lock`, then went FATAL — the exact signature covered by `ci-watcher-shared-verify-clone-lock-contention-fixed` memory. The fix (per-slug clone isolation `5620bdbe5f6` + quiet-skip-on-contention `e6ea1d33fc8`) is already merged to `origin/main2`, but the deployed root checkout (`HEAD` = `47b41af5a14`) is 19 commits behind and hasn't picked it up yet — this is deploy lag, not a new defect.

No JOB block — posting another `self-heal-fix` job would duplicate an already-merged fix. This will resolve once the next rolling deploy advances the root checkout past `e6ea1d33fc8`; systemd's
