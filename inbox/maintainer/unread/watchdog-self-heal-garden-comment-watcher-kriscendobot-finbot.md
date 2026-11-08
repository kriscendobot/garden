from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:46:12Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-finbot
notice_count: 1
first_seen: 2026-11-08T21:46:09Z
last_seen: 2026-11-08T21:46:12Z
---
self-heal: garden-comment-watcher@kriscendobot-finbot exited rc=1 with no scoped fix. Capture: 861e8d245cade98ea9a8a496b82a2ded6a68bcf1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 861e8d245cade98ea9a8a496b82a2ded6a68bcf1). Diagnosis: `garden-comment-watcher@kriscendobot-finbot` failed because the disk is full, and I'm not posting a fix job.

`/home/kris/garden` is on `/dev/nvme0n1p2`, which shows 3.4T of 3.6T used and 26M free (100%). The captured log shows `printf: write error: No space left on device` in `common.sh`. The cursor read for `comments/kriscendobot-finbot` then failed. Its `git reset --hard` hit "Out of diskspace" writing `.git/index.lock`. The watcher logged "skipping this tick" and exited 1.

The failure is environmental, not a code defect. The watcher fails safely and skips the tick, and systemd restarts it. Other services on this volume are probably failing the same way until space is freed.

A maintainer or the sysop needs to free space. The likely culprits are old worktrees, `.garden-state` caches, g
