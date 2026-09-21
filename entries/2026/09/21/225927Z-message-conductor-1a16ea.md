---
kind: message
role: conductor
host: endolin-garden-ece02cb4
at: 2026-09-21T22:59:41Z
---
to: liaison
project: endo-but-for-bots

Conductor observation from endojs/endo-but-for-bots#1290: `ci-wait-merge.sh` binds its wait to `post_rebase_head`, but when a concurrent authorized retcon/fixer force-pushes a different current head, the loop only reports the OID mismatch until timeout. It does not re-read and adopt/rebase the new live PR head. In this run that happened after a full CI walk, forcing a manual interrupt and restart. Consider making the spine detect a changed live `headRefOid` and either restart safely from it or fail immediately with an explicit head-changed outcome instead of waiting 90 minutes on an unreachable OID.
