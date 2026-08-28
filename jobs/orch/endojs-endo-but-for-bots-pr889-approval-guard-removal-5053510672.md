---
child-garden-current-head-approval-guard-remove-5053510672-host: endolin-garden-ece02cb4
child-garden-current-head-approval-guard-remove-5053510672-reap-count: 0
order: serial
children: garden-current-head-approval-guard-remove-5053510672 endojs-endo-but-for-bots-pr889-conduct-5053510672
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-28T17:36:19Z
---

Resolve kriskowal's approved review on endojs/endo-but-for-bots#889 as one
serial unit: first remove the garden's exact-current-head approval guard with
tests and documentation, then re-check and conduct the green approved PR to a
terminal merge. Halt if either child fails.
