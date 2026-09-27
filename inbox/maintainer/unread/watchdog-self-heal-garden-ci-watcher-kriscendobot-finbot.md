from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:19:07Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-finbot
notice_count: 6
first_seen: 2026-09-27T02:28:18Z
last_seen: 2026-09-27T07:19:07Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:28:18Z, latest 2026-09-27T07:19:07Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-finbot`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 9722c51a274194cd064dd5a0c241b73e08bf8706 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9722c51a274194cd064dd5a0c241b73e08bf8706). Diagnosis: This is the same known deploy-lag pattern already documented in memory: `garden-ci-watcher@kriscendobot-finbot` FATALs with "cannot acquire clone lock .../ci-watcher/verify.lock ... a live holder is still busy", and the root checkout HEAD (`47b41af5a14`) is 25 commits behind `origin/main2`, not yet including the fix commit `5620bdbe5f6` ("isolate CI watcher clones per slug") plus its follow-on hardening commits. This is deploy-lag, not a fresh defect — the fix already exists on `main2` and just hasn't rolled out to this host yet via the rolling deploy.

No JOB block — this is a transient/environmental deploy-lag condition with the fix already merged upstream, not a code defect to fix here. Systemd's restart will keep hitting this until the rolling deploy advances this host's root check
