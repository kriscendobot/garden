from_host: endolin-garden-ece02cb4
from: orchestrator:build-endo-inference-1357-orch-halted
msg_key: build-endo-inference-1357-orch-halted
notice_count: 1
first_seen: 2026-10-01T14:49:32Z
last_seen: 2026-10-01T14:49:34Z
sent_at: 2026-10-01T14:49:34Z
---
orchestration-event: orchestration-terminal
orchestration: build-endo-inference-1357-orch
orchestration-status: halted
child: build-endo-claude-backends-1357
failure-kind: handler-timeout
children-completed: 1
children-total: 2
halt-parked-remainder: 

Orchestration build-endo-inference-1357-orch HALTED: child build-endo-claude-backends-1357 stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 1/2 done before halt; parked remainder: none
