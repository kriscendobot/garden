---
order: serial
children: build-transcript-capture build-liaison-broadcast-reader
on-child-failure: halt
state: pending
created_by: orchestrator
created_at: 2026-07-06T23:40:03Z
---

Implement designs/transcript-journal-capture.md (landed d9c7ad6c7): durable fleet transcript archive on a transcripts2 orphan branch (inert until the maintainer arms config/transcripts-remote) plus fleet-wide cleanupPeriodDays=36500 disable. Child 1 builds the design's § Builder spec items 1-8 (code, units, launcher seed, tests, operator page); child 2 adds the liaison broadcast-reader (read-msgs.sh role/liaison+broadcast, per-host seen-key) and the bring-up arming surfacing in starting.md + roles/liaison/AGENT.md. Serial: child 2 edits docs that reference child 1's landed scripts. Supervisor: job supervise-transcript-capture (Fable).
