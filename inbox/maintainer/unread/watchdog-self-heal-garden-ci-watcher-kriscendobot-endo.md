from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T06:47:07Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-endo
notice_count: 6
first_seen: 2026-09-27T02:27:17Z
last_seen: 2026-09-27T06:47:07Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:27:17Z, latest 2026-09-27T06:47:07Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-endo`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-endo exited rc=1 with no scoped fix. Capture: 73f68790f3b991117d03730bd34cb711a4627f80 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 73f68790f3b991117d03730bd34cb711a4627f80). Diagnosis: This is the already-fixed shared-VERIFY-clone-lock contention bug for `garden-ci-watcher@kriscendobot-endo`: the FATAL "cannot acquire clone lock .../verify.lock after 3 waits" matches the exact signature covered by `5620bdbe5f6` (isolate CI watcher clones per slug) and `e6ea1d33fc8` (skip quietly on live-holder clone-lock contention), plus a chain of follow-up hardening commits (`ad55dea66f9`, `1570aa85a47`, `4692b4df0e7`, etc.) — all already merged to `origin/main2` but **not yet in this host's deployed root checkout** (HEAD `47b41af5a1` @ 2026-09-26 12:42 UTC is ~15 commits and ~15 hours behind `origin/main2` @ 586aee8196b). This is a deploy-lag recurrence, not a new defect — posting another `self-heal-fix` job would duplicate work already merged and waiting on the next deliberate `
