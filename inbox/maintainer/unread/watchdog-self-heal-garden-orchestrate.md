from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:37:16Z
watchdog_key: self-heal-garden-orchestrate
notice_count: 1
first_seen: 2026-11-08T17:08:31Z
last_seen: 2026-11-08T21:37:16Z
---
self-heal: garden-orchestrate exited rc=4 with no scoped fix. Capture: 524e145a753544fcb78f2e43953f33aedfcd6eb3 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 524e145a753544fcb78f2e43953f33aedfcd6eb3). Diagnosis: The cause is a full disk, not a code bug. `/home/kris/garden` is at 100% (3.6T total, 3.4T used, 4.0K free). `git config` couldn't write `config.lock` in the orchestrator's journal clone, and `common.sh` hit "No space left on device" on a `printf`. `garden-orchestrate` exited with code 4 because of that.

No code change would fix this, and systemd's restart will keep failing until space is freed. I'm not posting a self-heal-fix job. A job would need to write to the same full disk, and a deterministic slug would just repeat.

**What the maintainer needs to do:**
- Free space on the volume holding `/home/kris/garden`. Likely culprits are `worktrees/`, the per-job worktrees, `.garden-state` caches, and old build or `node_modules` trees. I did not run `du` to find out which.
- Consider running
