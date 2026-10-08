from_host: endolin-garden2-5bcdff64
from: orchestrator:orch-jev-triage-foreman-halted
msg_key: orch-jev-triage-foreman-halted
notice_count: 1
first_seen: 2026-10-08T04:28:24Z
last_seen: 2026-10-08T04:28:26Z
sent_at: 2026-10-08T04:28:26Z
---
orchestration-event: orchestration-terminal
orchestration: orch-jev-triage-foreman
orchestration-status: halted
child: trial-jev-triage-foreman-classification
failure-kind: gated-outcome-unsatisfied
children-completed: 1
children-total: 3
halt-parked-remainder: integrate-jev-triage-foreman

Orchestration orch-jev-triage-foreman HALTED: child trial-jev-triage-foreman-classification completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 1/3 done before halt; parked remainder: integrate-jev-triage-foreman
