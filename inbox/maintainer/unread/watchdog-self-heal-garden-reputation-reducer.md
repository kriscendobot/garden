from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T20:52:21Z
watchdog_key: self-heal-garden-reputation-reducer
notice_count: 1
first_seen: 2026-11-08T20:52:21Z
last_seen: 2026-11-08T20:52:21Z
---
self-heal: garden-reputation-reducer exited rc=1 with no scoped fix. Capture: 75f0c328722e1d5193ce0d91cd0f46feb36326c1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 75f0c328722e1d5193ce0d91cd0f46feb36326c1). Diagnosis: The `garden-reputation-reducer` failure came from a full disk, not a script bug, so I'm not posting a fix job.

The log tail has one line: `reputation-reduce.sh: line 39: printf: write error: No space left on device`. That is the `atomic_line` helper failing to write its temp file. `/home/kris/garden` is on `/dev/nvme0n1p2`, which is 100% full: 426M free of 3.6T, with 3.4T used. Any write on that volume can fail the same way, so other services on this host are likely to fail too.

The fix is to free space on that volume. Likely places to look are old worktrees under `worktrees/`, `.garden-state/`, git object stores that need a repack, and logs. I haven't checked which of these is holding the space, and this is a maintainer-level cleanup.

Once space is freed, systemd's restart should succe
