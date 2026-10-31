---
order: serial
children: shepherd-endojs-endo-but-for-bots-pr1589-gauntlet-resume-expanded-window
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-10-31T22:14:57Z
---

split-indivisible-reason: gauntlet retry sequencing and panel transitions are owned atomically by the gauntlet driver
split-indivisible-handler-timeout: 10800

The original shepherding task is indivisible because its halted gauntlet must be
resumed through the driver that owns retry sequencing, fresh-panel dispatch, and
subsequent review transitions. The single expanded-window child receives enough
time to supervise that state machine through its bounded CI and panel waits.
