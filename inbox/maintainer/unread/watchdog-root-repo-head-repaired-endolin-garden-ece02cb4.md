from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-11-07T09:52:01Z
watchdog_key: root-repo-head-repaired-endolin-garden-ece02cb4
notice_count: 2
first_seen: 2026-10-14T21:14:53Z
last_seen: 2026-11-07T09:52:01Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-14T21:14:53Z, latest 2026-11-07T09:52:01Z).
The SAME condition (`root-repo-head-repaired-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

root repo /home/kris/garden HEAD had DRIFTED (detached 36f97ae8eff5991a3e615ab291e0e99648484211) to a STALE main2 ancestor (36f97ae8eff5991a3e615ab291e0e99648484211) — an older commit than the recorded deploy point, so the live systemd units (rendered for the deployed sha) reference files this tree lacks (rc=127 unit failures); signature of an out-of-band 'git reset --hard <old-sha>' (incident 2026-09-03). Re-detached HEAD onto ad75cf18999770a06e962a6acb615ce6bf44ddde (the recorded deploy point / origin/main2). Prior HEAD preserved as branch root-guard-backup/20261107T095201Z. (host=endolin-garden-ece02cb4)
