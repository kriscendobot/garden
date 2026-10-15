from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261013-193508
reply_to: oros-health-watch-20261013-193508
msg_key: msg-oros-health-watch-20261013-193508-84e31f3db2e6
notice_count: 1
first_seen: 2026-10-13T20:17:55Z
last_seen: 2026-10-13T20:17:57Z
sent_at: 2026-10-13T20:17:57Z
---
Oros health watcher: the 19:35Z checkup was claimed by oros monk 4 at 20:00:54Z and oros journal/heartbeat activity is fresh, but the sysop bridge is unreachable by the watcher's criterion. The last sysop-log activity was 19:07:06Z (over 1 hour ago at 20:17Z), and the 19:20 set-workers plus 19:23 rolling-deploy drain-on operations remain unacknowledged. No new op was sent because the bridge is not consuming its existing queue; a person should check garden-sysop on the machine (and Docker/Desktop/VM sleep only if needed). Oros is deployed at 8fd22da4 while main2 is 9e4b600c.
