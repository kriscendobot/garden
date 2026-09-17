from_host: endolin-garden-ece02cb4
from: orchestrator:ironhorse-ocap-optimization-campaign-child-ironhorse-ocap-frozen-objects-failed
msg_key: ironhorse-ocap-optimization-campaign-child-ironhorse-ocap-frozen-objects-failed
notice_count: 1
first_seen: 2026-09-17T05:34:02Z
last_seen: 2026-09-17T05:34:05Z
sent_at: 2026-09-17T05:34:05Z
---
orchestration-event: orchestration-child-timeout
orchestration: ironhorse-ocap-optimization-campaign
orchestration-status: running
child: ironhorse-ocap-frozen-objects
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1)

Orchestration ironhorse-ocap-optimization-campaign observed child ironhorse-ocap-frozen-objects: stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1).
