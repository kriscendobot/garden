from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-10-14T21:14:54Z
watchdog_key: root-repo-head-repaired-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-10-14T21:14:53Z
last_seen: 2026-10-14T21:14:54Z
---
root repo /home/kris/garden HEAD had DRIFTED (detached 624ea1f3215039f40327addb32334804dff6a1a6) to a STALE main2 ancestor (624ea1f3215039f40327addb32334804dff6a1a6) — an older commit than the recorded deploy point, so the live systemd units (rendered for the deployed sha) reference files this tree lacks (rc=127 unit failures); signature of an out-of-band 'git reset --hard <old-sha>' (incident 2026-09-03). Re-detached HEAD onto 460f0598b585bab6bb2b6bc4151bc83ffbddb046 (the recorded deploy point / origin/main2). Prior HEAD preserved as branch root-guard-backup/20261014T211453Z. (host=endolin-garden-ece02cb4)
