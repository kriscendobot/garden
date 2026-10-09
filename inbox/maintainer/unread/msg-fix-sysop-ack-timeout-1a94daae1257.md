from_host: endolin-garden-ece02cb4
from: gardener:fix-sysop-ack-timeout
reply_to: fix-sysop-ack-timeout
msg_key: msg-fix-sysop-ack-timeout-1a94daae1257
notice_count: 1
first_seen: 2026-10-09T00:49:38Z
last_seen: 2026-10-09T00:49:40Z
sent_at: 2026-10-09T00:49:40Z
---
fix-sysop-ack-timeout landed on main2 as 96a2b4c6141 (the sysop spools and marks seen right after apply, writes records in one batch per tick, bounds restore's steps; budget-level skips re-sending a duplicate unacked set-workers). Remaining manual step, which can't be done from endolin: once oros-studio-garden-ce242c49 has deployed 96a2b4c6141, remove the temporary drop-in there:
  rm ~/.config/systemd/user/garden-sysop.service.d/zz-liaison-temp-timeout.conf && systemctl --user daemon-reload
The sysop vocabulary has no op that can remove it remotely.
