from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:24:06Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-minion-town
notice_count: 6
first_seen: 2026-09-27T01:58:17Z
last_seen: 2026-09-27T06:24:06Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T01:58:17Z, latest 2026-09-27T06:24:06Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-minion-town`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 0092bce6fb7932b97aaf621c42b04731b09d4ed0 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0092bce6fb7932b97aaf621c42b04731b09d4ed0). Diagnosis: Diagnosis: deploy-lag, not a defect — this host's root checkout (`47b41af5a14`) is 19 commits behind `origin/main2` (`586aee8196b`), and the clone-lock contention fixes (`5620bdbe5f6`, `e6ea1d33fc8`, plus follow-on hardening through `586aee8196b`) are already merged upstream but not yet rolled out here. `upgrade-monitor` just signaled `upgrade-ready` for this exact gap at 06:22:02 UTC, so the pending rolling deploy will resolve it. No JOB block posted; memory updated with this occurrence.
