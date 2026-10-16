---
role: shepherd
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-16T05:48:08Z cleared=none -->

---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Drive CI green for endojs/endo-but-for-bots PR #1398 after the Parcel restack

This is the second, serial stage of orchestration
`endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin-split`.
The preceding child aligns PR #1398's base, branch, seven-commit series, and PR
body. Begin from fresh GitHub state rather than assuming the historical head.

Drive all required CI for `endojs/endo-but-for-bots` PR #1398 to green. If runs
do not start, re-trigger them by the repository's established safe mechanism.
Inspect failures and fix only failures that belong to #1398. Use an isolated
project checkout keyed by this child job, test changes proportionally, preserve
the stacked seven-commit intent, and push with lease/CAS discipline.

Two failures seen on predecessor #1397 are known unrelated signals unless fresh
evidence ties them to #1398: Prettier in
`packages/patterns/test/rankCover.test.js`, and a macOS timeout in the daemon
`provider-listener-runtime` test. Do not paper over unrelated failures. Wait for
CI in the foreground with bounded polling; report the final head SHA and exact
check disposition. If a required check cannot be made green, genuinely finish
the diagnosis and emit the orchestrated failure signal required by the worker
prompt.

PR/Actions writes and head-branch fixes needed to fulfill this shepherding stage
are explicitly authorized by the parent job. Do not post the final PR completion
summary comment; the next serial child owns that after CI has settled.
