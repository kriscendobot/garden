---
child-endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-completion-summary-reap-count: 0
child-endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-ci-green-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-ci-green-reap-count: 0
child-endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-base-move-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-base-move endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-ci-green endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-completion-summary
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-16T05:06:15Z
---

# Finish PR #1396 as three serial, independently verifiable stages

The original work genuinely decomposes at durable GitHub boundaries: first move
and verify the PR base/diff, then wait for and repair CI, then publish the final
summary only after green evidence exists. The stages are serial because each
consumes the preceding stage's externally visible state. Halt on failure so a
summary is never posted for an incorrect base or non-green head.
