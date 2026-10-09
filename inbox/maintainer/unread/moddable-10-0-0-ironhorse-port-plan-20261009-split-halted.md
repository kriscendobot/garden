from_host: endolin-garden2-5bcdff64
from: orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-halted
msg_key: moddable-10-0-0-ironhorse-port-plan-20261009-split-halted
notice_count: 1
first_seen: 2026-10-09T23:38:52Z
last_seen: 2026-10-09T23:38:54Z
sent_at: 2026-10-09T23:38:54Z
---
orchestration-event: orchestration-terminal
orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split
orchestration-status: halted
child: moddable-10-0-0-xs-source-inventory-20261009
failure-kind: handler-timeout
children-completed: 0
children-total: 3
halt-parked-remainder: moddable-10-0-0-ironhorse-audit-20261009 moddable-10-0-0-ironhorse-port-plan-synthesis-20261009

Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split HALTED: child moddable-10-0-0-xs-source-inventory-20261009 stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/3 done before halt; parked remainder: moddable-10-0-0-ironhorse-audit-20261009 moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
