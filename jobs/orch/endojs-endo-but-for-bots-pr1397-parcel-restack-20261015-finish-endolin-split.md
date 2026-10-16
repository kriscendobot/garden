---
child-endojs-endo-but-for-bots-pr1397-parcel-restack-metadata-20261016-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1397-parcel-restack-metadata-20261016 endojs-endo-but-for-bots-pr1397-parcel-restack-ci-20261016 endojs-endo-but-for-bots-pr1397-parcel-restack-summary-20261016
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-16T03:54:40Z
---

# Finish the endojs/endo-but-for-bots PR #1397 Parcel restack

Serially finish the externally visible PR state after the code restack already
landed on the head branch: (1) move the PR to the frozen base and repair its
metadata while verifying the three-commit diff, (2) drive the resulting head's
required CI green and fix only attributable failures, then (3) publish and verify
the required completion summary. These are independently executable stages but
must run in order because each consumes remote state and evidence produced by its
predecessor. Halt on child failure so a summary cannot claim success before the
base move and CI outcome are established.
