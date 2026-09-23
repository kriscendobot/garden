from_host: endolin-garden-ece02cb4
from: orchestrator:credit-controls-20260916-halted
msg_key: credit-controls-20260916-halted
notice_count: 1
first_seen: 2026-09-16T07:04:17Z
last_seen: 2026-09-16T07:04:19Z
sent_at: 2026-09-16T07:04:19Z
---
orchestration-event: orchestration-terminal
orchestration: credit-controls-20260916
orchestration-status: halted
child: credit-controls-stale-pr-viability-gate
failure-kind: handler-timeout
children-completed: 2
children-total: 4
halt-parked-remainder: credit-controls-panel-seat-metering-and-tiering

Orchestration credit-controls-20260916 HALTED: child credit-controls-stale-pr-viability-gate stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 2/4 done before halt; parked remainder: credit-controls-panel-seat-metering-and-tiering
