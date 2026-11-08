from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T17:08:39Z
watchdog_key: self-heal-garden-monk
notice_count: 1
first_seen: 2026-11-08T17:08:36Z
last_seen: 2026-11-08T17:08:39Z
---
self-heal: garden-monk exited rc=1 with no scoped fix. Capture: cfdc8f484b78b0e3f7bb8b73a0502d68d058f99c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p cfdc8f484b78b0e3f7bb8b73a0502d68d058f99c). Diagnosis: garden-monk exited 1 because the disk is full, so the cause is environmental and there is no code fix to post. I'm emitting no JOB block.

**What happened:** the monk had been polling the board normally, skipping jobs that need other host capabilities. At 17:08:21 its hard reset of `.garden-state/monks/1/journal` to `origin/journal2` failed with `.git/index.lock write error. Out of diskspace`. That made the claim step fail, so the monk exited with rc=1. `/home/kris/garden` is on `/dev/nvme0n1p2`, which is 100% used (3.4T of 3.6T, 107M free).

**What to do:**
- **Free space.** The maintainer or a host-repair pass should free space on this volume. I did not delete anything. Each monk's journal worktree is about 780M, and there are at least three of them. The usual candidates are large caches
