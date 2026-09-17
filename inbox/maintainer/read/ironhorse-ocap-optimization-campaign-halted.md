from_host: endolin-garden-ece02cb4
from: orchestrator:ironhorse-ocap-optimization-campaign-halted
msg_key: ironhorse-ocap-optimization-campaign-halted
notice_count: 1
first_seen: 2026-09-17T05:34:20Z
last_seen: 2026-09-17T05:34:22Z
sent_at: 2026-09-17T05:34:22Z
---
orchestration-event: orchestration-terminal
orchestration: ironhorse-ocap-optimization-campaign
orchestration-status: halted
child: ironhorse-ocap-frozen-objects
failure-kind: handler-timeout
children-completed: 2
children-total: 4
halt-parked-remainder: ironhorse-ocap-campaign-audit

Orchestration ironhorse-ocap-optimization-campaign HALTED: child ironhorse-ocap-frozen-objects stalled in flight for 7359s on host endolin-garden2-5bcdff64 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 2/4 done before halt; parked remainder: ironhorse-ocap-campaign-audit
