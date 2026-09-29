from_host: endolin-garden-ece02cb4
from: orchestrator:retire-gardener-worker-kind-alias-split-child-retire-gardener-worker-kind-alias-env-fallback-failed
msg_key: retire-gardener-worker-kind-alias-split-child-retire-gardener-worker-kind-alias-env-fallback-failed
notice_count: 1
first_seen: 2026-09-29T21:01:13Z
last_seen: 2026-09-29T21:01:14Z
sent_at: 2026-09-29T21:01:14Z
---
orchestration-event: orchestration-child-timeout
orchestration: retire-gardener-worker-kind-alias-split
orchestration-status: running
child: retire-gardener-worker-kind-alias-env-fallback
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1)

Orchestration retire-gardener-worker-kind-alias-split observed child retire-gardener-worker-kind-alias-env-fallback: stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
