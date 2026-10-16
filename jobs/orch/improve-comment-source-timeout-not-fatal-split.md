---
child-improve-comment-source-timeout-not-fatal-expanded-window-host: oros-studio-garden-ce242c49
child-improve-comment-source-timeout-not-fatal-expanded-window-reap-count: 0
order: serial
children: improve-comment-source-timeout-not-fatal-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-16T02:33:43Z
---

Split of `improve-comment-source-timeout-not-fatal` after a 2400s deadline overrun.

split-indivisible-reason: the fix is already implemented as one tested commit on a side branch, and what remains is a single serial land-and-verify; comment-watcher-test.sh alone runs more than 10 minutes on oros-studio
split-indivisible-handler-timeout: 5400
