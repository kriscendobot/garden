from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:28:53Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-list
notice_count: 8
first_seen: 2026-09-27T01:56:23Z
last_seen: 2026-09-27T07:28:53Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-27T01:56:23Z, latest 2026-09-27T07:28:53Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-list`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-list exited rc=1 with no scoped fix. Capture: af2b4d5e945a6ddaff2e55a30a4d530f7a2a2310 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p af2b4d5e945a6ddaff2e55a30a4d530f7a2a2310). Diagnosis: This is the known, already-fixed clone-lock contention bug — confirmed deploy-lag, not a new defect.

Root checkout HEAD (`47b41af5a14`) is 24 commits behind `origin/main2` (now at `c942c685af2`), and none of the fix commits (`5620bdbe5f6`, `e6ea1d33fc8`, `5b48813cd0b`, and the follow-on hardening chain) are ancestors of HEAD yet. The failure signature — `clone lock .../ci-watcher/verify.lock busy >60s` → `FATAL: cannot acquire clone lock ... after 3 waits ... a live holder is still busy` — matches [[ci-watcher-shared-verify-clone-lock-contention-fixed]] and [[ci-watcher-clone-lock-contention-fix-queued-not-deployed]] exactly: this host simply hasn't rolled forward through the rolling-deploy yet. Posting another `self-heal-fix-garden-ci-watcher-*` job would just rediscover the same
