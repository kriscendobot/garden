from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T22:41:16Z
watchdog_key: self-heal-garden-rolling-deploy
notice_count: 2
first_seen: 2026-10-18T08:53:51Z
last_seen: 2026-11-08T22:41:16Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-18T08:53:51Z, latest 2026-11-08T22:41:16Z).
The SAME condition (`self-heal-garden-rolling-deploy`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

self-heal: garden-rolling-deploy exited rc=1 with no scoped fix. Capture: 6af0d107bee4e61adaa20524e698e522bf7b0e5c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 6af0d107bee4e61adaa20524e698e522bf7b0e5c). Diagnosis: `garden-rolling-deploy` failed because the disk is full. No code fix applies, so I'm not posting a job.

The log shows one fatal error at 22:41:03. The hard reset of the rolling-deploy journal worktree to `origin/journal2` failed on retry with "Out of diskspace" while writing `.git/index.lock`.

`df` shows `/home/kris/garden` at 100% (3.4T of 3.6T used, 22M free). The rolling-deploy worktree is only 787M, so it isn't the cause.

systemd will keep restarting the service and it will keep failing until space is freed. The other units that write to the journal or git objects are probably failing the same way.

A person needs to find what is filling the volume and clear space. Likely candidates are worktree and bare-clone growth under `worktrees/`, `.garden-state/`, per-job tmp directories, and
