from_host: endolin-garden2-5bcdff64
from: watchdog:foreman
sent_at: 2026-10-06T02:04:25Z
watchdog_key: foreman-handler-failed-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-10-06T02:04:25Z
last_seen: 2026-10-06T02:04:25Z
---
garden-foreman's pump handler (/home/kris/garden2/scripts/jobs/handlers/foreman-claude.sh) failed rc=1 on endolin-garden2-5bcdff64; the board pump is starving. stderr tail: <6>02:04:25 [foreman-claude] foreman anthropic provider skipped: configured Claude quota is at its high-water mark
<6>02:04:25 [foreman-claude] foreman provider 'anthropic' unavailable; trying the next configured provider
<3>02:04:25 [foreman-claude] FATAL: no configured foreman inference provider was available
