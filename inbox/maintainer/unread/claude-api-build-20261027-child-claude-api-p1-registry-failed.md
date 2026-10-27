from_host: endolin-garden-ece02cb4
from: orchestrator:claude-api-build-20261027-child-claude-api-p1-registry-failed
msg_key: claude-api-build-20261027-child-claude-api-p1-registry-failed
notice_count: 1
first_seen: 2026-10-27T06:20:47Z
last_seen: 2026-10-27T06:20:49Z
sent_at: 2026-10-27T06:20:49Z
---
orchestration-event: orchestration-child-timeout
orchestration: claude-api-build-20261027
orchestration-status: running
child: claude-api-p1-registry
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 7253s on host endolin-garden-ece02cb4 (handler-timeout=7200s, multiplier=1)

Orchestration claude-api-build-20261027 observed child claude-api-p1-registry: stalled in flight for 7253s on host endolin-garden-ece02cb4 (handler-timeout=7200s, multiplier=1).
