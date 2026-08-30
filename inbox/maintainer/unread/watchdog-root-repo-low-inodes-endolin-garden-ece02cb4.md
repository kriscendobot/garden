from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-08-30T04:52:00Z
watchdog_key: root-repo-low-inodes-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-08-30T04:52:00Z
last_seen: 2026-08-30T04:52:00Z
---
host filesystem inode headroom is CRITICAL: filesystem /dev/nvme0n1p2 mounted at /home/kris/garden (the filesystem backing /home/kris/garden) has 11635759/244121600 free inodes (4.77%), below the 5% threshold. This is filesystem-wide inode exhaustion, distinct from byte-capacity exhaustion: filesystem and git writes can fail with 'No space left on device' even while bytes remain. No automatic deletion was attempted because cleanup must first prove each candidate worktree's job is in jobs/tada and remove it through the owning worktree mechanism. Review completed per-job worktrees and their node_modules, then reclaim a bounded batch and re-check 'df -i /home/kris/garden'. (host=endolin-garden-ece02cb4)
