from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:53:53Z
watchdog_key: self-heal-garden-repo-watcher
notice_count: 1
first_seen: 2026-11-08T21:53:53Z
last_seen: 2026-11-08T21:53:53Z
---
self-heal: garden-repo-watcher exited rc=1 with no scoped fix. Capture: 7951df331065cc3e62c112d4143351ebfa5cc26f (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 7951df331065cc3e62c112d4143351ebfa5cc26f). Diagnosis: No fix job is warranted: `garden-repo-watcher` failed because the disk is full.

The `/home/kris/garden` filesystem is at 100%, with 3.4T of 3.6T used and about 3.5M available. The captured log shows the cause. `git reset --hard origin/journal2` failed in the `fork-watch` and `repo-watcher` journal clones with `index.lock write error. Out of diskspace`. The watcher's journal prerequisite then failed, so it exited with code 1. Inodes are fine, at 68% used.

This is an environmental fault. The watcher script behaved correctly, and any other service writing to this filesystem will likely fail the same way. Editing the watcher would not help.

An operator needs to free space on the host, for example by pruning old worktrees, bare-repo garbage, or build and cache directories under `/home/kris/g
