from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:26:53Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-moddable
notice_count: 2
first_seen: 2026-09-27T02:26:27Z
last_seen: 2026-09-27T04:26:53Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:26:27Z, latest 2026-09-27T04:26:53Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-moddable`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-moddable exited rc=1 with no scoped fix. Capture: 80d67610011624adad0aa9b5bc364c4e47fb9bff (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 80d67610011624adad0aa9b5bc364c4e47fb9bff). Diagnosis: This is the already-fixed deploy-lag case my memory flagged: [ci-watcher shared verify clone lock contention, fixed](ci-watcher-shared-verify-clone-lock-contention-fixed.md).

**Diagnosis:** `garden-ci-watcher@kriscendobot-moddable` failed with the exact known signature — `FATAL: cannot acquire clone lock .../ci-watcher/verify.lock after 3 waits`. The root fix (commits `5620bdbe5f` isolating CI-watcher clones per repo slug, and `e6ea1d33fc` making lock contention a quiet transient-outage skip instead of a fatal exit) is already on `main2` (`origin/main2` @ `586aee8196b`) but **not yet deployed to this host** — the deployed root is still at `47b41af5a1`, 19 commits behind. The `upgrade-ready` marker confirms this: it was written at `2026-09-27T04:22:03Z`, the same minute the contention 
