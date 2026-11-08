from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T23:57:34Z
watchdog_key: self-heal-garden-orchestrate
notice_count: 3
first_seen: 2026-11-08T17:08:31Z
last_seen: 2026-11-08T23:57:34Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-08T17:08:31Z, latest 2026-11-08T23:57:34Z).
The SAME condition (`self-heal-garden-orchestrate`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

self-heal: garden-orchestrate exited rc=1 with no scoped fix. Capture: 9adcba3f1bbd31c9c7d986070bdb24a01d31ec9c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 9adcba3f1bbd31c9c7d986070bdb24a01d31ec9c). Diagnosis: `garden-orchestrate` failed because the disk is full, so there is no code fix to post and I'm not emitting a JOB block.

The filesystem holding the garden (`/dev/nvme0n1p2`, 3.6T, 3.4T used) shows 0 bytes available at 100%. Inodes are fine, at 68% used. The log tail shows three symptoms:
- `common.sh` line 176 hit `printf: write error: No space left on device`.
- Git failed to write `.git/index.lock` in `.garden-state/orch/journal`.
- The orchestrator exited on `FATAL: hard reset ... to origin/journal2 failed after retry ... Out of diskspace`.

The script handled the failure as designed, and systemd will keep restarting it. It will keep failing until space is freed, and any other unit that writes to this volume is likely failing the same way.

A human needs to free space on that volume. Th
