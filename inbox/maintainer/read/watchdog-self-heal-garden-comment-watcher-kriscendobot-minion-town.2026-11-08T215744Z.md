from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:57:44Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-minion-town
notice_count: 1
first_seen: 2026-09-26T05:18:59Z
last_seen: 2026-11-08T21:57:44Z
---
self-heal: garden-comment-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: 58f31577374e3361151bcf1742fe0270f551c21d (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 58f31577374e3361151bcf1742fe0270f551c21d). Diagnosis: The watcher failed because the disk is full, so I'm not posting a fix job.

`/home/kris/garden` is on `/dev/nvme0n1p2`, which is 100% used with 375M free of 3.6T. The captured log tail shows the failure chain:

- `printf: write error: No space left on device` appeared in `common.sh`.
- `cursor-get` then failed to hard-reset its journal cursor worktree to `origin/journal2`. It couldn't write `budget/decisions/2026-11-08-endolin-garden-ece02cb4.jsonl`.
- The comment-watcher logged "cursor read failed … skipping this tick" and exited 1.

Nothing in the watcher script is wrong. Every other service that writes to that volume will hit the same error until space is freed. A job to fix this watcher would only add load to a full disk.

**For the maintainer:** free space on that volume. Likely can
