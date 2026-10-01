from_host: endolin-garden-ece02cb4
from: orchestrator:build-endo-inference-1357-orch-child-build-endo-claude-backends-1357-failed
msg_key: build-endo-inference-1357-orch-child-build-endo-claude-backends-1357-failed
notice_count: 1
first_seen: 2026-10-01T14:49:12Z
last_seen: 2026-10-01T14:49:14Z
sent_at: 2026-10-01T14:49:14Z
---
orchestration-event: orchestration-child-timeout
orchestration: build-endo-inference-1357-orch
orchestration-status: running
child: build-endo-claude-backends-1357
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1)

Orchestration build-endo-inference-1357-orch observed child build-endo-claude-backends-1357: stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1).
