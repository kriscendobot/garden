from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:07:33Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-ymax-e2e
notice_count: 1
first_seen: 2026-11-08T22:05:59Z
last_seen: 2026-11-08T22:07:33Z
---
self-heal: garden-comment-watcher@kriscendobot-ymax-e2e exited rc=1 with no scoped fix. Capture: 7203544246ef32a76f871ffd13a1033846d133ec (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 7203544246ef32a76f871ffd13a1033846d133ec). Diagnosis: No fix job to post: `garden-comment-watcher@kriscendobot-ymax-e2e` failed because the disk is full, which is environmental, not a code bug.

The captured output shows `common.sh: line 176: printf: write error: No space left on device`. That is where the exit-1 came from. `df` shows `/home/kris/garden` (`/dev/nvme0n1p2`, 3.6T) at 100% with 496K available. The watcher's own last line, logged just after the failing write, says it found no new comments on `kriscendobot/ymax-e2e`. The watcher logic itself is working.

Until space is freed, any service that writes to `.garden-state` or the journal can fail the same way, so expect more units to fail. A maintainer needs to free space on that volume, for example by pruning old worktrees, bare-clone packs, logs or build caches. A job can't do that s
