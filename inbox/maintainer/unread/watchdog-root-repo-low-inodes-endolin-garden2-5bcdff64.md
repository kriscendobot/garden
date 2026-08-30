from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-08-30T07:22:00Z
watchdog_key: root-repo-low-inodes-endolin-garden2-5bcdff64
notice_count: 3
first_seen: 2026-08-30T04:52:00Z
last_seen: 2026-08-30T07:22:00Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-08-30T04:52:00Z, latest 2026-08-30T07:22:00Z).
The SAME condition (`root-repo-low-inodes-endolin-garden2-5bcdff64`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

host filesystem inode headroom is CRITICAL: filesystem /dev/nvme0n1p2 mounted at /home/kris/garden2 (the filesystem backing /home/kris/garden2) has 11934750/244121600 free inodes (4.89%), below the 5% threshold. This is filesystem-wide inode exhaustion, distinct from byte-capacity exhaustion: filesystem and git writes can fail with 'No space left on device' even while bytes remain. No automatic deletion was attempted because cleanup must first prove each candidate worktree's job is in jobs/tada and remove it through the owning worktree mechanism. Review completed per-job worktrees and their node_modules, then reclaim a bounded batch and re-check 'df -i /home/kris/garden2'. (host=endolin-garden2-5bcdff64)
