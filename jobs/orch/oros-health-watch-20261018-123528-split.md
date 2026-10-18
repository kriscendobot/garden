---
order: serial
children: oros-health-watch-20261018-123528-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-18T13:46:21Z
---

split-indivisible-reason: The health verdict and any sysop intervention form one stateful observation-and-escalation cycle; separate workers could duplicate operations or act on inconsistent host state.
split-indivisible-handler-timeout: 7200

Run the recurring oros health watch as one expanded-window child. Its required 40-minute observation and minute-scale sysop acknowledgment waits must share one worker's state and single-operation limits.
