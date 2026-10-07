from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-10-07T05:17:43Z
watchdog_key: root-repo-head-repaired-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-10-07T05:17:23Z
last_seen: 2026-10-07T05:17:43Z
---
root repo /home/kris/garden2 HEAD had DRIFTED (detached d309b9384a374326a5462abab0ac30a9d288e8b2) to a STALE main2 ancestor (d309b9384a374326a5462abab0ac30a9d288e8b2) — an older commit than the recorded deploy point, so the live systemd units (rendered for the deployed sha) reference files this tree lacks (rc=127 unit failures); signature of an out-of-band 'git reset --hard <old-sha>' (incident 2026-09-03). Re-detached HEAD onto de4f2eece5f746c23d8bac7b3634b8aecfeb7ef6 (the recorded deploy point / origin/main2). Prior HEAD preserved as branch root-guard-backup/20261007T051723Z. (host=endolin-garden2-5bcdff64)
