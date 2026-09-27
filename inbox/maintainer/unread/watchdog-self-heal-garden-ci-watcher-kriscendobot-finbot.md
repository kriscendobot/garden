from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T04:16:26Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-finbot
notice_count: 2
first_seen: 2026-09-27T02:28:18Z
last_seen: 2026-09-27T04:16:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:28:18Z, latest 2026-09-27T04:16:26Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-finbot`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 3cd604f8ac267b3ee023387498a5a51c26bbcc6c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 3cd604f8ac267b3ee023387498a5a51c26bbcc6c). Diagnosis: This is deploy-lag, not a new defect. The failure signature — `garden-ci-watcher@kriscendobot-finbot FATAL: cannot acquire clone lock .../verify.lock after 3 waits` — is exactly the shared-VERIFY-clone contention bug already fixed by `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder contention), both present on `origin/main2` but not yet on this host's deployed root checkout (HEAD is 19 commits behind main2, a clean ancestor — no divergence). Per [[ci-watcher-shared-verify-clone-lock-contention-fixed]], this is exactly the "check deploy-lag before posting another self-heal-fix job" case.

No JOB block — this needs the deliberate rolling deploy to catch this host up, not a new code fix (posting another fix job would be a duplicate of a
