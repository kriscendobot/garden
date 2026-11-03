from_host: endolin-garden-ece02cb4
from: orchestrator:improve-gardener-handler-rc76-collision-split-halted
msg_key: improve-gardener-handler-rc76-collision-split-halted
notice_count: 1
first_seen: 2026-11-03T22:42:42Z
last_seen: 2026-11-03T22:42:44Z
sent_at: 2026-11-03T22:42:44Z
---
orchestration-event: orchestration-terminal
orchestration: improve-gardener-handler-rc76-collision-split
orchestration-status: halted
child: improve-gardener-handler-rc76-collision-expanded-window
failure-kind: handler-timeout
children-completed: 0
children-total: 1
halt-parked-remainder: 

Orchestration improve-gardener-handler-rc76-collision-split HALTED: child improve-gardener-handler-rc76-collision-expanded-window stalled in flight for 7270s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 0/1 done before halt; parked remainder: none
