from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:15:21Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-ocapn
notice_count: 4
first_seen: 2026-09-22T00:22:39Z
last_seen: 2026-11-08T22:15:21Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-22T00:22:39Z, latest 2026-11-08T22:15:21Z).
The SAME condition (`self-heal-garden-receipt-watcher-kriscendobot-ocapn`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

self-heal: garden-receipt-watcher@kriscendobot-ocapn exited rc=1 with no scoped fix. Capture: ccee23b51954f38fdcf96f1bac075b11ae394b14 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ccee23b51954f38fdcf96f1bac075b11ae394b14). Diagnosis: The `garden-receipt-watcher@kriscendobot-ocapn` failure is a full disk, not a code bug, so I'm posting no fix job.

The service exited 1 with `FATAL: receipt journal prerequisite failed for kriscendobot/ocapn (rc=4)`. Underneath that, `printf` reported "No space left on device". Git then could not write `.garden-state/receipt-watcher/journal-kriscendobot-ocapn/.git/config.lock` while `ensure_clone` was setting `user.name`.

`df` shows `/home/kris/garden` at 100% (3.4T of 3.6T used, 0 available). Any other unit that writes to that filesystem will probably fail the same way. Systemd's restart will keep failing until space is freed.

The fix is operational: free space on that volume. Likely places to look are old worktrees, aborted-repack garbage in the shared root repo (the sysop `maintain` 
