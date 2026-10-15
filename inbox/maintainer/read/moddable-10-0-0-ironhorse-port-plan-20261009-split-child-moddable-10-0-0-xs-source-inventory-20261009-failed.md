from_host: endolin-garden2-5bcdff64
from: orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-child-moddable-10-0-0-xs-source-inventory-20261009-failed
msg_key: moddable-10-0-0-ironhorse-port-plan-20261009-split-child-moddable-10-0-0-xs-source-inventory-20261009-failed
notice_count: 1
first_seen: 2026-10-09T23:38:34Z
last_seen: 2026-10-09T23:38:35Z
sent_at: 2026-10-09T23:38:35Z
---
orchestration-event: orchestration-child-timeout
orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split
orchestration-status: running
child: moddable-10-0-0-xs-source-inventory-20261009
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1)

Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split observed child moddable-10-0-0-xs-source-inventory-20261009: stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1).
