from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:56:21Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-minion-town
notice_count: 4
first_seen: 2026-09-27T01:58:17Z
last_seen: 2026-09-27T04:56:21Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T01:58:17Z, latest 2026-09-27T04:56:21Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-minion-town`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: d394f0fa7bebb50d745f68cc2df0ef8720c6e0f2 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p d394f0fa7bebb50d745f68cc2df0ef8720c6e0f2). Diagnosis: This confirms the root cause: this host (`endolin-garden-ece02cb4`) is already flagged `upgrade-ready`, 19 commits behind `main2`, and detected at 04:52:01Z — right when the clone-lock contention started (04:53:45Z onward). The fix for this exact failure class already landed on `main2`; it just hasn't rolled out to this host yet.

No fix job needed — this is the known **deploy-lag** recurrence of the already-fixed shared-verify-clone-lock bug, matching prior incidents in memory (`ci-watcher-clonelock-stderr-deploy-lag`, `ci-watcher-clone-lock-contention-fixed`). The rolling/leader-orchestrated deploy should pick up `upgrade-ready` and advance this host to `586aee8196b`, which resolves it. No JOB block is warranted since posting another self-heal-fix for an already-fixed-upstream bug wo
