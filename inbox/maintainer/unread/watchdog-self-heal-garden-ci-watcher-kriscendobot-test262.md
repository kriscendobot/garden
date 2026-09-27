from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T05:03:48Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-test262
notice_count: 2
first_seen: 2026-09-27T03:25:52Z
last_seen: 2026-09-27T05:03:48Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T03:25:52Z, latest 2026-09-27T05:03:48Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-test262`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-test262 exited rc=1 with no scoped fix. Capture: 3c9f46f6f7cdd2f803dccf0fd6a51d81d374af81 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 3c9f46f6f7cdd2f803dccf0fd6a51d81d374af81). Diagnosis: This is confirmed deploy-lag, not a new bug. The deployed root checkout (HEAD `47b41af5a14`) is 19 commits behind `origin/main2`, and the fix commits for this exact failure signature (`5620bdbe5f6` isolate-per-slug clone, `e6ea1d33fc8`/`5b48813cd0b` latch busy-holder as transient outage, plus follow-on hardening through `586aee8196b`) are all sitting unmerged ahead of HEAD. This matches the known pattern in memory ([[ci-watcher-shared-verify-clone-lock-contention-fixed]], [[ci-watcher-clone-lock-contention-fix-queued-not-deployed]]): the deliberate rolling-deploy hasn't rolled this host forward yet.

No fix needed — posting another `self-heal-fix-garden-ci-watcher-*` job would just rediscover the same already-landed fix. This will self-resolve once the rolling deploy advances this host's
