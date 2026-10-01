from_host: endolin-garden-ece02cb4
from: orchestrator:retire-gardener-worker-kind-alias-env-fallback-split-child-retire-gardener-clone-alias-verify-deploy-reaper-failed
msg_key: retire-gardener-worker-kind-alias-env-fallback-split-child-retire-gardener-clone-alias-verify-deploy-reaper-failed
notice_count: 1
first_seen: 2026-09-30T23:13:10Z
last_seen: 2026-09-30T23:13:11Z
sent_at: 2026-09-30T23:13:11Z
---
orchestration-event: orchestration-child-timeout
orchestration: retire-gardener-worker-kind-alias-env-fallback-split
orchestration-status: running
child: retire-gardener-clone-alias-verify-deploy-reaper
failure-kind: handler-timeout
order: parallel
on-child-failure: continue
detail: stalled in flight for 2412s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1)

Orchestration retire-gardener-worker-kind-alias-env-fallback-split observed child retire-gardener-clone-alias-verify-deploy-reaper: stalled in flight for 2412s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).
