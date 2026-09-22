from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-09-22T06:22:51Z
watchdog_key: root-repo-dirty-tree-repaired-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-21T22:22:06Z
last_seen: 2026-09-22T06:22:51Z
---
root repo /home/kris/garden2 had a STRAY TRACKED EDIT (the no-development-in-the-root invariant was violated). It was PRESERVED (branch root-guard-backup/20260922T062250Z + patch /home/kris/garden2/.garden-state/deploy/dirty-tree-backups/20260922T062250Z.patch) and the tracked tree restored to clean so the rolling deploy is never wedged behind a dirty-tree abort. This is an after-the-fact FYI — the fleet keeps moving. Preserved paths:  M scripts/jobs/common.sh; M scripts/jobs/test/cursor-outage-cooldown-test.sh. (host=endolin-garden2-5bcdff64)
