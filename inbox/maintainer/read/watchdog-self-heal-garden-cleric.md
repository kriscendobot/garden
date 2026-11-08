from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T20:52:26Z
watchdog_key: self-heal-garden-cleric
notice_count: 1
first_seen: 2026-11-08T20:52:23Z
last_seen: 2026-11-08T20:52:26Z
---
self-heal: garden-cleric exited rc=1 with no scoped fix. Capture: bc557e29afc960f91e0e8d9444878cfe0ca8c425 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p bc557e29afc960f91e0e8d9444878cfe0ca8c425). Diagnosis: The cleric worker failed because the disk is full. A fix job wouldn't help, so I'm not posting one.

`/home/kris/garden` is on `/dev/nvme0n1p2`, which is 100% used (3.4T of 3.6T, 428M free). The cleric's `claim-job.sh` tried to clone the journal, and the checkout died with "No space left on device" on hundreds of `inbox/maintainer/read/*` files. It then logged `FATAL: claim failed (rc=1)`, and systemd restarts the service.

Any restart will hit the same error until space is freed, and other services that clone or write the journal will probably fail the same way.

**What the maintainer needs to do:** free space on that volume. The likeliest sources are accumulated clones and worktrees under `.garden-state/` (self-heal, monitors, verify clones), stale `worktrees/`, and old `drop/` content. 
