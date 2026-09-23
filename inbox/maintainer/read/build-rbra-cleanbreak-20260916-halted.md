from_host: endolin-garden-ece02cb4
from: orchestrator:build-rbra-cleanbreak-20260916-halted
msg_key: build-rbra-cleanbreak-20260916-halted
notice_count: 1
first_seen: 2026-09-17T05:37:24Z
last_seen: 2026-09-17T05:37:39Z
sent_at: 2026-09-17T05:37:39Z
---
orchestration-event: orchestration-terminal
orchestration: build-rbra-cleanbreak-20260916
orchestration-status: halted
child: build-rbra-clean-break-20260916
failure-kind: handler-timeout
children-completed: 1
children-total: 3
halt-parked-remainder: build-rbra-rename-conformance-20260916

Orchestration build-rbra-cleanbreak-20260916 HALTED: child build-rbra-clean-break-20260916 stalled in flight for 10921s on host endolin-garden-ece02cb4 (handler-timeout=10800s, multiplier=1) (serial, on-child-failure=halt). 1/3 done before halt; parked remainder: build-rbra-rename-conformance-20260916
