from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:56:08Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp
notice_count: 2
first_seen: 2026-09-27T02:00:56Z
last_seen: 2026-09-27T04:56:08Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:00:56Z, latest 2026-09-27T04:56:08Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-ymax-stdio-mcp`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-ymax-stdio-mcp exited rc=1 with no scoped fix. Capture: 94b6c1f8dd55e609ebab1b2b950790dfe3eab04c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 94b6c1f8dd55e609ebab1b2b950790dfe3eab04c). Diagnosis: Confirmed deploy-lag: the deployed root checkout (HEAD `47b41af5a14`) is 19 commits behind `origin/main2`, and all the relevant clone-lock fixes (`5620bdbe5f6`, `e6ea1d33fc8`, and follow-on hardening through `586aee8196b`) are already merged upstream but not yet rolled out via the deliberate rolling deploy. This exact FATAL signature is the known, already-fixed shared-VERIFY-clone contention bug — not a new defect.

No JOB block emitted; this will self-resolve once the rolling deploy advances the root checkout past `586aee8196b`.
