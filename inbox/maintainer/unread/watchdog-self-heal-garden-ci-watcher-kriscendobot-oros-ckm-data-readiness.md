from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:47:16Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 5
first_seen: 2026-09-27T03:10:57Z
last_seen: 2026-09-27T06:47:16Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-27T03:10:57Z, latest 2026-09-27T06:47:16Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-oros-ckm-data-readiness`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 3a41006b56ccfc499f3da0764c07c0278a4908e3 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 3a41006b56ccfc499f3da0764c07c0278a4908e3). Diagnosis: This is the already-fixed shared-VERIFY-clone-lock contention bug (memory: `ci-watcher-shared-verify-clone-lock-contention-fixed` / `ci-watcher-clone-lock-contention-fix-queued-not-deployed`). The failure signature matches exactly: `ci-watcher/kriscendobot-oros-ckm-data-readiness` backed off 2 retries then hit `FATAL: cannot acquire clone lock .../verify.lock`. I confirmed the deployed root checkout is 19 commits behind `origin/main2`, and the fix commits (`5620bdbe5f6` isolate CI watcher clones per slug, `e6ea1d33fc8` skip quietly on live-holder contention, plus a string of follow-on hardening commits like `ad55dea66f9`, `1570aa85a47`, `ab66fece68f`) are all present on `origin/main2` but not yet in this host's deployed HEAD (`47b41af5a14`).

This is a deploy-lag situation, not a fresh cod
