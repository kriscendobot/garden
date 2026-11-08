from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:27:34Z
watchdog_key: self-heal-garden-transcript-capture
notice_count: 1
first_seen: 2026-11-08T22:27:34Z
last_seen: 2026-11-08T22:27:34Z
---
self-heal: garden-transcript-capture exited rc=1 with no scoped fix. Capture: dfddf750a1b7b391871b44b5bfdfbd568da1a82a (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p dfddf750a1b7b391871b44b5bfdfbd568da1a82a). Diagnosis: `garden-transcript-capture` failed because the disk is full. I'm not posting a fix job: the cause is environmental, and the capture script isn't at fault.

The captured output shows `printf: write error: No space left on device` from `common.sh` line 176. It also shows `cp: error writing ... .jsonl.gz: No space left on device`. `df` confirms it: `/home/kris/garden` is on a 3.6T volume with 3.4T used and 0 bytes available (100%). The transcripts directory itself is only 12G, so it isn't the main consumer.

Fixing this means freeing space on that volume. That is an operator decision, such as pruning old worktrees, caches or build artifacts, or expanding the volume.

Every other writer on the volume will fail the same way until space is freed. That includes journal pushes and gardener jobs. s
