---
order: serial
children: improve-deadline-nudge-ref-race-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-05T21:04:07Z
---

Single-child split of improve-deadline-nudge-ref-race after a deadline overrun.

split-indivisible-reason: one atomic change (classifier predicate in common.sh + its regression test); the overrun came from the ~10 min deadline-nudge test suite under host load, not size. The verified patch (deadline-nudge 57/0) is carried in the child body; the child applies, re-verifies once, and lands it.
split-indivisible-handler-timeout: 5400
