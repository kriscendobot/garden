from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-10-03T06:52:02Z
watchdog_key: root-repo-dirty-tree-repaired-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-09-12T13:22:02Z
last_seen: 2026-10-03T06:52:02Z
---
root repo /home/kris/garden had a STRAY TRACKED EDIT (the no-development-in-the-root invariant was violated). It was PRESERVED (branch root-guard-backup/20261003T065202Z + patch /home/kris/garden/.garden-state/deploy/dirty-tree-backups/20261003T065202Z.patch) and the tracked tree restored to clean so the rolling deploy is never wedged behind a dirty-tree abort. This is an after-the-fact FYI — the fleet keeps moving. Preserved paths:  M roles/jurors/curator/AGENT.md. (host=endolin-garden-ece02cb4)
