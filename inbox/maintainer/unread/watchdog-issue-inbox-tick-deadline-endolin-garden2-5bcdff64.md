from_host: endolin-garden2-5bcdff64
from: watchdog:issue-inbox
sent_at: 2026-09-23T04:32:03Z
watchdog_key: issue-inbox-tick-deadline-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-23T04:31:59Z
last_seen: 2026-09-23T04:32:03Z
---
issue-inbox watcher on endolin-garden2-5bcdff64 hit its 480s tick budget before the batch for kriscendobot/garden and stopped early to avoid the 900s systemd start-timeout SIGKILL. This means a journal/verification/dispatch path is running slow (a DEGRADED journal, not a clean outage). No maintainer interaction is lost — the cursor holds so unprocessed items re-poll — but each tick is being cut short; if this persists, the journal remote or the host's network is chronically slow.
