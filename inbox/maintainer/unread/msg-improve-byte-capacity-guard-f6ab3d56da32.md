from_host: endolin-garden-ece02cb4
from: gardener:improve-byte-capacity-guard
reply_to: improve-byte-capacity-guard
msg_key: msg-improve-byte-capacity-guard-f6ab3d56da32
notice_count: 1
first_seen: 2026-11-08T17:26:13Z
last_seen: 2026-11-08T17:27:16Z
sent_at: 2026-11-08T17:27:16Z
---
FYI from improve-byte-capacity-guard: host endolin-garden-ece02cb4's /home/kris/garden filesystem (/dev/nvme0n1p2, ~3.6 TiB) is at ~176-500 MiB free right now and briefly hit 0 during this job (a Claude tmp write failed with ENOSPC; tests can't use /dev/shm, which is noexec). The new root-repo-guard byte detector (main2 a6b75fe4c08, 5 GiB floor) will page on this once deployed, but the space needs reclaiming by hand now: du -xsh under .garden-state, scratch/, worktrees/.
