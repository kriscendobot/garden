---
child-endojs-endo-but-for-bots-pr1170-botanist-finish-20260906-reap-count: 0
child-endojs-endo-but-for-bots-pr1170-stabilize-ci-20260906-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1170-stabilize-ci-20260906-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1170-stabilize-ci-20260906 endojs-endo-but-for-bots-pr1170-botanist-finish-20260906
on-child-failure: halt
state: running
created_by: botanist
created_at: 2026-09-06T22:03:04Z
---

# Complete Dependabot PR #1170 after systemic cold-CI failures

First stabilize the unrelated timing-sensitive and external-mirror CI failures
on the reviewed PR head. Then run a fresh botanist terminal check and execute the
appropriate disposition, including verdict comment and decision ledger. The
serial boundary prevents merger review from proceeding until the repair stage
has completed successfully.
