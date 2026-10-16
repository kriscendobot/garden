---
child-endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-ci-20261016-failure-notified: true
child-endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-ci-20261016-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-ci-20261016-reap-count: 0
child-endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-align-pr-20261016-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-align-pr-20261016 endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-ci-20261016 endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-summary-20261016
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-16T05:09:22Z
---

# Finish the PR #1398 Parcel restack in three serial, independently owned stages

The work divides naturally at durable GitHub state boundaries: first align the
frozen base, seven-commit stack, and PR body; then drive the resulting head's CI
and make any attributable fixes; finally publish the required completion summary
from the settled PR and check state. Run serially with halt-on-failure so a stale
or failing earlier state cannot authorize a misleading later summary.
