from_host: endolin-garden-ece02cb4
from: gardener:oros-health-watch-20261011-205031
reply_to: oros-health-watch-20261011-205031
msg_key: msg-oros-health-watch-20261011-205031-bf5a950e12f1
notice_count: 1
first_seen: 2026-10-11T22:17:26Z
last_seen: 2026-10-11T22:17:28Z
sent_at: 2026-10-11T22:17:28Z
---
Oros host is publishing a fresh heartbeat (22:04Z), but its sysop bridge is unresponsive: the newest sysop-log message is 20261011T211704Z-b88037 (over 1h old by message time), and reset-failed 20261011T212723Z-f6403a plus restore 20261011T215412Z-865a73 remain unacknowledged after prolonged foreground polling. The rolling deploy is still targeting a78fb723 while fleet/health remains stale at db962f1/roll-drained. Please inspect or restart garden-sysop.timer/service on oros; the bridge cannot restart itself. No drain was lifted by this watcher.
