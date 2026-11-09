from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-11-09T02:22:02Z
watchdog_key: root-repo-head-repaired-endolin-garden-ece02cb4
notice_count: 3
first_seen: 2026-10-14T21:14:53Z
last_seen: 2026-11-09T02:22:02Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-14T21:14:53Z, latest 2026-11-09T02:22:02Z).
The SAME condition (`root-repo-head-repaired-endolin-garden-ece02cb4`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

root repo /home/kris/garden HEAD had DRIFTED (detached e522b2762e0f915bb3761df44681dc2bb1e8a36a) to a STALE main2 ancestor (e522b2762e0f915bb3761df44681dc2bb1e8a36a) — an older commit than the recorded deploy point, so the live systemd units (rendered for the deployed sha) reference files this tree lacks (rc=127 unit failures); signature of an out-of-band 'git reset --hard <old-sha>' (incident 2026-09-03). Re-detached HEAD onto f2788117645dde4304eb6a8dd98c59a9050ad56c (the recorded deploy point / origin/main2). Prior HEAD preserved as branch root-guard-backup/20261109T022202Z. (host=endolin-garden-ece02cb4)
