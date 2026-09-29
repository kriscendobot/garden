from_host: endolin-garden-ece02cb4
from: orchestrator:retire-gardener-worker-kind-alias-split-halted
msg_key: retire-gardener-worker-kind-alias-split-halted
notice_count: 1
first_seen: 2026-09-29T21:01:37Z
last_seen: 2026-09-29T21:01:39Z
sent_at: 2026-09-29T21:01:39Z
---
orchestration-event: orchestration-terminal
orchestration: retire-gardener-worker-kind-alias-split
orchestration-status: halted
child: retire-gardener-worker-kind-alias-env-fallback
failure-kind: handler-timeout
children-completed: 0
children-total: 2
halt-parked-remainder: retire-gardener-worker-kind-alias-verify-docs

Orchestration retire-gardener-worker-kind-alias-split HALTED: child retire-gardener-worker-kind-alias-env-fallback stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/2 done before halt; parked remainder: retire-gardener-worker-kind-alias-verify-docs
