---
order: serial
children: improve-deadline-nudge-failure-trace-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-30T00:08:42Z
---

Deliberate deadline-overrun split of `improve-deadline-nudge-failure-trace` (overran its 2400s handler wall once). Judged indivisible: one child with a larger window.

split-indivisible-reason: "one coupled mechanism in one ~60-line region of scripts/jobs/deadline-nudge.sh: the tick subshell's ERR/EXIT traps and the explicit-status stage paths of deadline_nudge_tick must write one local fault record that the parent's WARN at the end of the script reads; a writer-only or reader-only child is unverifiable alone and both would edit the same lines, so the overrun was reproduce-and-test cost, not breadth"
split-indivisible-handler-timeout: 4800
