from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-09-27T07:19:15Z
watchdog_key: self-heal-garden-ci-watcher-kriscendobot-test262
notice_count: 6
first_seen: 2026-09-27T03:25:52Z
last_seen: 2026-09-27T07:19:15Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T03:25:52Z, latest 2026-09-27T07:19:15Z).
The SAME condition (`self-heal-garden-ci-watcher-kriscendobot-test262`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

self-heal: garden-ci-watcher@kriscendobot-test262 exited rc=1 with no scoped fix. Capture: 0d455c8ff0856b5ded63fe18ce8198f5b30c7837 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 0d455c8ff0856b5ded63fe18ce8198f5b30c7837). Diagnosis: This is the known clone-lock contention failure (`ci-watcher@kriscendobot-test262` FATAL after 3×60s backoff waiting on `.garden-state/ci-watcher/verify.lock`), not a new defect. The fix already landed on `main2` as a whole chain of commits (`5620bdbe5f6` isolate CI watcher clones per slug, `e6ea1d33fc8` skip quietly on live-holder contention, plus `c38cb55b172`, `4948cdd9a75`, `9dbda9d5573`, `02adfdaf324`, `49cf6544668`, `ad55dea66f9`, `ab66fece68f`, `1570aa85a47`, `4692b4df0e7`, `586aee8196b`, `f92ecdb0a3f`) — but this root checkout's HEAD (`47b41af5a14`, 2026-09-26) is 25 commits behind `origin/main2` (`c942c685af2`), so the deployed code here still hits the old hard-FATAL path. This is deploy lag, not a code defect: no fix job needed, systemd's restart is fine, and the next `deploy-
