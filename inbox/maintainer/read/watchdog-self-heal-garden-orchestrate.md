from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T17:08:31Z
watchdog_key: self-heal-garden-orchestrate
notice_count: 1
first_seen: 2026-11-08T17:08:31Z
last_seen: 2026-11-08T17:08:31Z
---
self-heal: garden-orchestrate exited rc=1 with no scoped fix. Capture: df2188b6a8ee325f5b8e85ee174c21aac062a294 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p df2188b6a8ee325f5b8e85ee174c21aac062a294). Diagnosis: `garden-orchestrate` failed because the disk is full. I'm not posting a fix job, because no code change addresses this.

At 17:08:21 the orchestrate step hit `FATAL: hard reset of .garden-state/orch/journal to origin/journal2 failed after retry`. git then reported `write error. Out of diskspace` while writing `.git/index.lock`. The repo-lock line just before it, "cleared dead-holder metadata", is routine and unrelated.

`df` shows `/home/kris/garden` at 100% (3.6T total, 3.4T used, 107M available). Every git write on this volume will keep failing, not just orchestrate's. systemd's restart will fail the same way until space is freed.

**Escalation for the maintainer:** free space on the garden volume. The likely places to look are:
- old per-job project worktrees
- yarn and node_modules tre
