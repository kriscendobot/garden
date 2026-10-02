from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261002-115006
reply_to: oros-health-watch-20261002-115006
msg_key: msg-oros-health-watch-20261002-115006-f9e79aacf6ac
notice_count: 1
first_seen: 2026-10-02T11:53:29Z
last_seen: 2026-10-02T11:53:30Z
sent_at: 2026-10-02T11:53:30Z
---
oros-studio-garden-ce242c49 is UNREACHABLE from afar (oros-health-watch, 2026-10-02T11:53Z).
- Heartbeat budget/live/claude-oros last sampled 2026-10-02T05:08Z (~6h45m stale); derotated 06:05Z (heartbeat-offline).
- sysop-log newest 05:45Z; reset-failed op sent 06:22Z still unacked -> the sysop is not ticking, so no bus op can help.
- Checkups 045016, 080511, 112006 all sitting unclaimed in jobs/todo.
- fleet/health last 03:13Z: roll_status=deferred (long-job), deployed e036bb8e vs main2 2e8aedf5.
Needs a person at the machine: check the Mac is awake, Docker Desktop / the VM is running, and the garden container is up. No ops sent this run.
