---
order: serial
children: endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922-expanded-window
on-child-failure: halt
state: pending
created_by: orchestrator
created_at: 2026-10-15T13:25:45Z
---

split-indivisible-reason: The Parcel semantic adaptation changes the same commit range that must be rebased and conflict-resolved against PR #1392, so splitting would make either child operate on a non-final history and invalidate patch-identity and exact-head CI evidence.
split-indivisible-handler-timeout: 10800

This serial orchestration gives the indivisible #1393 Parcel reconciliation and
restack enough time to complete its coherent PR mutation and exact-head
validation after the original 2400-second handler wall was exceeded.
