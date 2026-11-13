from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T23:52:24Z
watchdog_key: self-heal-garden-reputation-reducer
notice_count: 2
first_seen: 2026-11-08T20:52:21Z
last_seen: 2026-11-08T23:52:24Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-08T20:52:21Z, latest 2026-11-08T23:52:24Z).
The SAME condition (`self-heal-garden-reputation-reducer`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-reputation-reducer exited rc=1 with no scoped fix. Capture: 75f0c328722e1d5193ce0d91cd0f46feb36326c1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 75f0c328722e1d5193ce0d91cd0f46feb36326c1). Diagnosis: The `garden-reputation-reducer` failure came from a full disk, not from a bug in the script. This is environmental, so there is no fix job to post.

`scripts/jobs/reputation-reduce.sh` line 39 failed with `printf: write error: No space left on device`, which caused the exit code 1. `/dev/nvme0n1p2`, which holds `/home/kris/garden`, is at 100%, with 243M free of 3.6T.

Any script that writes under the garden root can fail the same way until space is freed. Someone needs to free space on that volume. Likely candidates are old worktrees, `.garden-state` caches and journal blobs, build artifacts, and stale self-heal blobs. The reducer will recover on its own once writes succeed again. I'm not posting a self-heal-fix job, since it would also fail on the full disk and would not fix the cause.
