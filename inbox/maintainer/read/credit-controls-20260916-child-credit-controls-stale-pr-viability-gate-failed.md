from_host: endolin-garden-ece02cb4
from: orchestrator:credit-controls-20260916-child-credit-controls-stale-pr-viability-gate-failed
msg_key: credit-controls-20260916-child-credit-controls-stale-pr-viability-gate-failed
notice_count: 1
first_seen: 2026-09-16T07:04:02Z
last_seen: 2026-09-16T07:04:03Z
sent_at: 2026-09-16T07:04:03Z
---
orchestration-event: orchestration-child-timeout
orchestration: credit-controls-20260916
orchestration-status: running
child: credit-controls-stale-pr-viability-gate
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1)

Orchestration credit-controls-20260916 observed child credit-controls-stale-pr-viability-gate: stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
