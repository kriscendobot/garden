from_host: endolin-garden-ece02cb4
from: orchestrator:claude-on-minion-town-press-20261013-072006-split-child-claude-on-minion-town-press-carry-20261013-failed
msg_key: claude-on-minion-town-press-20261013-072006-split-child-claude-on-minion-town-press-carry-20261013-failed
notice_count: 1
first_seen: 2026-10-13T14:57:03Z
last_seen: 2026-10-13T14:57:05Z
sent_at: 2026-10-13T14:57:05Z
---
orchestration-event: orchestration-child-timeout
orchestration: claude-on-minion-town-press-20261013-072006-split
orchestration-status: running
child: claude-on-minion-town-press-carry-20261013
failure-kind: handler-timeout
order: serial
on-child-failure: halt
detail: stalled in flight for 2474s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1)

Orchestration claude-on-minion-town-press-20261013-072006-split observed child claude-on-minion-town-press-carry-20261013: stalled in flight for 2474s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1).
