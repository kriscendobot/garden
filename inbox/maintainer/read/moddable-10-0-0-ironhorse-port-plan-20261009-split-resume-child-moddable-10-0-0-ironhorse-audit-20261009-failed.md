from_host: endolin-garden2-5bcdff64
from: orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-child-moddable-10-0-0-ironhorse-audit-20261009-failed
msg_key: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-child-moddable-10-0-0-ironhorse-audit-20261009-failed
notice_count: 1
first_seen: 2026-10-10T02:06:03Z
last_seen: 2026-10-10T02:06:04Z
sent_at: 2026-10-10T02:06:04Z
---
orchestration-event: orchestration-child-timeout
orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume
orchestration-status: running
child: moddable-10-0-0-ironhorse-audit-20261009
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1)

Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume observed child moddable-10-0-0-ironhorse-audit-20261009: stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1).
