from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-08T21:14:47Z
watchdog_key: self-heal-garden-repo-watcher
notice_count: 1
first_seen: 2026-11-08T21:14:47Z
last_seen: 2026-11-08T21:14:47Z
---
self-heal: garden-repo-watcher exited rc=1 with no scoped fix. Capture: e4b923ecaf9053557df1a12fcba85039e5df7225 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e4b923ecaf9053557df1a12fcba85039e5df7225). Diagnosis: The `garden-repo-watcher` failure is environmental: the disk is full, and no code change will fix it. I'm not posting a fix job.

`/home/kris/garden` is on `/dev/nvme0n1p2`, which `df` shows as 3.6T total, 3.4T used, 0 available, at 100%. The captured log shows every write failing:
- `printf: write error: No space left on device` at `common.sh:176`.
- `failed to write new configuration file .../fork-watch/journal/.git/config.lock`, which made `fork-watch-provisioner` return rc=4.
- The same lock-file error in the `repo-watcher` journal, which triggered the FATAL "journal prerequisite failed (rc=4)" and the exit 1.

The watcher exited cleanly because it couldn't write its prerequisites. Systemd restarts will keep failing the same way until space is freed. Other services that write to the jo
