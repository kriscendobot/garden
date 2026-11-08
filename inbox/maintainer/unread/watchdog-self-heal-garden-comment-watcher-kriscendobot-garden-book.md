from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:36:28Z
watchdog_key: self-heal-garden-comment-watcher-kriscendobot-garden-book
notice_count: 1
first_seen: 2026-11-08T21:36:28Z
last_seen: 2026-11-08T21:36:28Z
---
self-heal: garden-comment-watcher@kriscendobot-garden-book exited rc=1 with no scoped fix. Capture: 188ce146ed87a7616e46bf643ecdf9208e9de872 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 188ce146ed87a7616e46bf643ecdf9208e9de872). Diagnosis: `garden-comment-watcher@kriscendobot-garden-book` failed because the disk is full. I'm not posting a fix job, because no script change addresses it.

The captured log shows `printf: write error: No space left on device` from `common.sh`. The cursor read for `comments/kriscendobot-garden-book` then failed, with `cursor-get` unable to write `.git/index.lock` during its hard reset of the journal cursor clone. The watcher logged a "skipping this tick" warning and exited 1.

`df` on `/home/kris/garden` confirms it: the 3.6T filesystem is 100% used with 0 available. Every other garden service writing to this filesystem will fail the same way until space is freed. Systemd's restart will keep failing the same way until then, and I expect other units to start failing too.

**For the maintainer:** f
