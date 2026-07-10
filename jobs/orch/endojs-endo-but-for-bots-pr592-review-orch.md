---
order: serial
children: endojs-endo-but-for-bots-pr592-cancel-in-options endojs-endo-but-for-bots-pr592-watchdir-coverage
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-10T17:07:45Z
---

# Orchestration: resolve PR #592 review (pullrequestreview-4673410829, @kriskowal)

Serial pipeline resolving the whole CHANGES_REQUESTED review on
endojs/endo-but-for-bots#592 (factor watchDirectory into @endo/platform):

1. endojs-endo-but-for-bots-pr592-cancel-in-options (fixer) — address the two
   inline comments: fold `cancelled` into the watchDirectory options bag
   (default forever-pending) and adopt @endo/cancel makeCancelKit for the
   mount-level cancellation fold. API-shape refactor, behavior invariant.
2. endojs-endo-but-for-bots-pr592-watchdir-coverage (cleaner) — the review
   body's ask: increase test coverage on the new watchDirectory features.

Serial (not parallel) because both touch the same source and test files; the
cleaner writes tests against the FINAL cancellation signature the fixer lands.
