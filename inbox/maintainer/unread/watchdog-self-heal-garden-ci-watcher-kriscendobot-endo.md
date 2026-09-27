from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:17:48Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo
notice_count: 4
first_seen: 2026-09-27T02:27:17Z
last_seen: 2026-09-27T05:17:48Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-27T02:27:17Z, latest 2026-09-27T05:17:48Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: e6693b035e689467923e3b018820426a60e34566 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e6693b035e689467923e3b018820426a60e34566). Diagnosis: Confirmed: this is the same deploy-lag false positive documented in memory, not a new bug.

The failure is `garden-ci-watcher@kriscendobot-endo` (endo-but-for-bots slug) hitting `cannot acquire clone lock .../ci-watcher/verify.lock` — the known shared-VERIFY-clone contention signature. The fix (`5620bdbe5f6` isolate-per-slug clones, plus `e6ea1d33fc8`/`5b48813cd0b` outage-latch belt-and-suspenders, and further hardening through `586aee8196b`) is already on `origin/main2` but the deployed root checkout (HEAD `47b41af5a14`, 2026-09-26) is still 19 commits behind. This is deploy lag, not a fresh defect — the deliberate rolling deploy just hasn't rolled these commits out to this host yet.

No JOB block emitted; systemd's restart plus the eventual rolling deploy will resolve it. I'll leave 
