from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:54:03Z
watchdog_key: self-heal-garden-receipt-watcher-kriscendobot-oros-ckm-data-readiness
notice_count: 1
first_seen: 2026-09-22T02:04:17Z
last_seen: 2026-11-08T21:54:03Z
---
self-heal: garden-receipt-watcher@kriscendobot-oros-ckm-data-readiness exited rc=1 with no scoped fix. Capture: 8f1e1406de703a956a7ec5890df9ac8e3eb40c06 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 8f1e1406de703a956a7ec5890df9ac8e3eb40c06). Diagnosis: The `garden-receipt-watcher@kriscendobot-oros-ckm-data-readiness` failure is environmental: the disk is full, so no fix job is warranted.

The captured tail shows the hard reset of its journal clone to `origin/journal2` failing with `fatal: sha1 file '.../journal-kriscendobot-oros-ckm-data-readiness/.git/index.lock' write error. Out of diskspace`. The watcher reported this as the "receipt journal prerequisite failed" FATAL, exit 1.

`df` on `/home/kris/garden` confirms it: `/dev/nvme0n1p2` is 3.6T with 3.4T used and 4.0K available (100%). Any git write on this host will fail the same way, so other garden units are probably failing too. The receipt-watcher code has no bug here.

**Action for the maintainer:** free space on `/home/kris/garden`. The usual suspects are bloated object stores or
