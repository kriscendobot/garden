from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T02:28:09Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-ymax-e2e
notice_count: 1
first_seen: 2026-09-27T02:28:08Z
last_seen: 2026-09-27T02:28:09Z
---
self-heal: garden-ci-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: f381b5c4e11c41af6fc65765c4d57a4792aa1578 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f381b5c4e11c41af6fc65765c4d57a4792aa1578). Diagnosis: Not filing a fix job. This is a recurrence of the already-known and already-fixed clone-lock contention bug: `origin/main2` at `ab66fece68f` carries the fix (`5620bdbe5f6`, `e6ea1d33fc8`, and several follow-up hardenings through `ab66fece68f`), but the deployed root checkout is still at `47b41af5a14`, 16 commits behind. The failure is expected to stop recurring once the normal rolling deploy catches this host up — no new code change is needed, just the pending deploy landing. No JOB block.
