from_host: endolin-garden-ece02cb4
from: orchestrator:improve-enforce-handler-wall-bound-split-child-improve-enforce-handler-wall-bound-watchdog-failed
msg_key: improve-enforce-handler-wall-bound-split-child-improve-enforce-handler-wall-bound-watchdog-failed
notice_count: 1
first_seen: 2026-10-27T15:54:25Z
last_seen: 2026-10-27T15:54:27Z
sent_at: 2026-10-27T15:54:27Z
---
orchestration-event: orchestration-child-timeout
orchestration: improve-enforce-handler-wall-bound-split
orchestration-status: running
child: improve-enforce-handler-wall-bound-watchdog
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2556s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1)

Orchestration improve-enforce-handler-wall-bound-split observed child improve-enforce-handler-wall-bound-watchdog: stalled in flight for 2556s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).
