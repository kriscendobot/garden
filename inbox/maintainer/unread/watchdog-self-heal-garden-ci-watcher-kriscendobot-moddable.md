from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:55:54Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-moddable
notice_count: 6
first_seen: 2026-09-27T02:26:27Z
last_seen: 2026-09-27T06:55:54Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:26:27Z, latest 2026-09-27T06:55:54Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-moddable`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-moddable exited rc=1 with no scoped fix. Capture: 0d2f9b22ac3f0ebb4a9f4b11fdab06204d7dfbc9 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0d2f9b22ac3f0ebb4a9f4b11fdab06204d7dfbc9). Diagnosis: This failure is the already-diagnosed shared-VERIFY-clone-lock contention bug (`garden-ci-watcher@kriscendobot-moddable` FATAL "cannot acquire clone lock .../verify.lock" after 3×60s backoff), fixed upstream by commits `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention). I confirmed both are present on `origin/main2`, but the deployed root checkout (`HEAD` = `47b41af5a14`) is currently 19 commits behind `origin/main2` — this is deploy lag, not a code defect requiring a new fix. Per the deliberate-deploy model, the root checkout only advances via the governed `deploy-garden.sh` rolling deploy, not via a self-heal fix job, and posting another `self-heal-fix-*` job here would just duplicate work already merged upstream awaiting depl
