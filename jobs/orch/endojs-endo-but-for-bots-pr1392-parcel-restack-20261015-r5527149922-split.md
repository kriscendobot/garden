---
order: serial
children: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-15T11:45:30Z
---

# Expanded-window continuation for PR #1392

split-indivisible-reason: Parcel adaptation, explicit history-preserving rebase, lease-protected branch/base updates, and exact-head CI form one atomic PR mutation; splitting would expose an intermediate head and invalidate downstream verification.
split-indivisible-handler-timeout: 10800

The single child owns the complete reconciliation, restack, validation, CI, and
completion-summary operation for PR #1392. The enlarged claim window reflects
the observed runtime of the immediately preceding PR #1391 operation while
keeping one owner for the moving branch and its exact-head evidence.
