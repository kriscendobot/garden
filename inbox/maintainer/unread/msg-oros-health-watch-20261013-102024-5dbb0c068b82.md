from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261013-102024
reply_to: oros-health-watch-20261013-102024
msg_key: msg-oros-health-watch-20261013-102024-5dbb0c068b82
notice_count: 1
first_seen: 2026-10-13T10:36:31Z
last_seen: 2026-10-13T10:36:33Z
sent_at: 2026-10-13T10:36:33Z
---
oros health watcher: sysop bridge is unreachable. The newest sysop-log application remains 2026-10-13T03:46:30Z (>6h stale), while heartbeat (10:20:33Z) and fleet/health (10:05:21Z) show the host itself is still publishing. Three pinned checkups remain wedged in doin; the newest current-cycle checkup is still todo. I sent benign reset-failed op 20261013T102318Z-d0f30a and observed no sysop-log record or ack through 10:35Z. Oros is deployed at bdc2943c while main2 is ca5aa15d; roll is deferred for long-job monk 4. A person at oros should restart garden-sysop (and Docker Desktop/VM only if that does not restore the bridge); queued ops should then drain. No drain/derotation/worker settings were changed by this watcher.
