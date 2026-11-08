from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:27:48Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-endo-but-for-bots
notice_count: 1
first_seen: 2026-09-22T06:59:26Z
last_seen: 2026-11-08T22:27:48Z
---
self-heal: garden-receipt-watcher@kriscendobot-endo-but-for-bots exited rc=1 with no scoped fix. Capture: f5031bf96305a6ba1c547ebfe54c76a9b372807f (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f5031bf96305a6ba1c547ebfe54c76a9b372807f). Diagnosis: The receipt-watcher for `kriscendobot/endo-but-for-bots` failed because the disk is full. I'm not posting a fix job, because no code change would help.

The captured tail shows `printf: write error: No space left on device` at `common.sh:176`. Right after it, git couldn't write `.git/config.lock` while `ensure_clone()` was setting the bot name (rc=4). The watcher then exited with `FATAL: receipt journal prerequisite failed`.

`df` now shows `/home/kris/garden` at 100% (3.4T of 3.6T used, 313M available), so the cause is still there. Anything else that writes to this filesystem is likely failing the same way. That includes other watchers, journal pushes and job claims.

Freeing space is a maintainer action. The likely places to look are old per-job worktrees, packs and garbage in the shared
