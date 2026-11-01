---
child-oros-health-watch-20261101-192009-expanded-window-reap-count: 0
order: serial
children: oros-health-watch-20261101-192009-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-11-01T21:37:00Z
---

Split of `oros-health-watch-20261101-192009` after a deadline overrun.

split-indivisible-reason: The watcher is one sequential observation of a single checkup's lifecycle. Its spec has built-in wait windows (up to ~45 min for the claim, then up to ~40 min of progress watching, plus multi-minute sysop ack round-trips) that alone exceed 3600s, and none of them can be done in parallel or handed between independent children.
split-indivisible-handler-timeout: 7200
