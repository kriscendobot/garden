from_host: endolin-garden2-5bcdff64
from: orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-halted
msg_key: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-halted
notice_count: 1
first_seen: 2026-10-10T02:06:21Z
last_seen: 2026-10-10T02:06:23Z
sent_at: 2026-10-10T02:06:23Z
---
orchestration-event: orchestration-terminal
orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume
orchestration-status: halted
child: moddable-10-0-0-ironhorse-audit-20261009
failure-kind: handler-timeout
children-completed: 0
children-total: 2
halt-parked-remainder: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009

Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume HALTED: child moddable-10-0-0-ironhorse-audit-20261009 stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/2 done before halt; parked remainder: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
