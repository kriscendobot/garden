from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-11-07T01:52:02Z
watchdog_key: root-repo-head-repaired-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-10-14T21:14:53Z
last_seen: 2026-11-07T01:52:02Z
---
root repo /home/kris/garden HEAD had DRIFTED (detached 78d2b028796f3200ec1a7065e13ac4083fbceeb6) to a STALE main2 ancestor (78d2b028796f3200ec1a7065e13ac4083fbceeb6) — an older commit than the recorded deploy point, so the live systemd units (rendered for the deployed sha) reference files this tree lacks (rc=127 unit failures); signature of an out-of-band 'git reset --hard <old-sha>' (incident 2026-09-03). Re-detached HEAD onto dd3e6bc6edfd490eb8ba0936b8b79a78238088ca (the recorded deploy point / origin/main2). Prior HEAD preserved as branch root-guard-backup/20261107T015202Z. (host=endolin-garden-ece02cb4)
