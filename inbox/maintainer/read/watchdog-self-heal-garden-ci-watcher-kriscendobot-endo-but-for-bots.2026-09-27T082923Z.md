from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T08:29:23Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo-but-for-bots
notice_count: 8
first_seen: 2026-09-27T03:10:42Z
last_seen: 2026-09-27T08:29:23Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T03:10:42Z, latest 2026-09-27T08:29:23Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo-but-for-bots`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: e91154a65b544d33c186f8b37a0dc1dd380c0882 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e91154a65b544d33c186f8b37a0dc1dd380c0882). Diagnosis: This is the well-documented deploy-lag false positive (memory: `ci-watcher-clone-lock-contention-fix-queued-not-deployed`, `ci-watcher-shared-verify-clone-lock-contention-fixed`). The failure signature — `clone lock .../ci-watcher/verify.lock busy >60s ... FATAL: cannot acquire clone lock ... after 3 waits of 60s and 0 reclaim attempt(s)` — matches exactly, and this host's root checkout (`HEAD` = `47b41af5a14`) is still 36 commits behind `origin/main2` (`773813fb50`), which already carries the layered fix chain (`5620bdbe5f6`, `e6ea1d33fc8`, `5b48813cd0b`, and follow-ons). The rolling deploy hasn't rolled this host forward yet — there's a stuck-canary marker for `endolin-garden2-5bcdff64` in `.garden-state/rolling-deploy/`, which the watchdog already owns and will escalate on its own
