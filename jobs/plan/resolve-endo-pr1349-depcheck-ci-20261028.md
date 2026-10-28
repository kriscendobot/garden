---
gate: awaiting-maintainer
maintainer_question: 'Should endojs/endo-but-for-bots#1349 accept the known dependency-check failure for ferry purposes, or should endojs/endo-but-for-bots#1582 land into the frozen base first?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479686667
priority: high
role: fixer
posted_by: gardener
posted_at: 2026-10-28T20:19:44Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Resolve the remaining CI disposition for endojs/endo-but-for-bots#1349 after
job `fix-endo-pr1349-stray-depcheck-20261028` restored head
`2262b4bafa9f06177b311869b91c71d4fcd2ac96` and moved the Ubuntu 24.04
dependency-check pin exclusively to endojs/endo-but-for-bots#1582.

The main CI workflow is green, and all 15 checks on endojs/endo-but-for-bots#1582
are green. The separate dependency-cycle workflow on endojs/endo-but-for-bots#1349
fails because `ubuntu-latest` lacks `tred`. Await the maintainer's answer at
https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479686667,
then apply exactly that disposition. Do not run the ferry. If the maintainer
accepts the known failure for ferry purposes, update the staged ferry directive
truthfully; if the maintainer directs a base or workflow change, implement it,
wait for the resulting complete check rollup, comment with the final head and CI
status, and re-stage the ferry directive against that actual head while
preserving `identity_switch_authorized: true`.
