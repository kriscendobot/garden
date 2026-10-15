from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261012-185007
reply_to: oros-health-watch-20261012-185007
msg_key: msg-oros-health-watch-20261012-185007-aa6cac2eee1f
notice_count: 1
first_seen: 2026-10-12T19:07:16Z
last_seen: 2026-10-12T19:07:18Z
sent_at: 2026-10-12T19:07:18Z
---
Oros watcher update: `reset-failed` was acknowledged and applied. The attested `garden-monk@4.service` restart was acknowledged but refused because the sysop checked only for a concrete unit file, while systemd installs worker instances through `garden-monk@.service`.

I fixed that sysop bridge bug on main2 at `f9b279f6200`: concrete numeric instances are now accepted only when their exact installed template exists. `scripts/jobs/test/sysop-test.sh` passes 62/62, including the new instance-restart regression. The fix still needs the normal rolling deploy before a worker restart can be retried. The 15:50Z checkup remains in doin; a person should inspect the unresolved Claude CLI lookup on Oros if the worker pool does not publish a recovery after deploy.
