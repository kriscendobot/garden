---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-05T15:45:01Z
---
# Dependabot review complete — endojs/endo-but-for-bots PR 918

Verdict: REJECT.
Disposition: posted https://github.com/endojs/endo-but-for-bots/pull/918#issuecomment-5193963736 and closed the PR at 2026-08-05T15:44:03Z.

Base `llm` resolves the affected direct sites to @babel/types 7.29.0, so the PR was live rather than superseded. The scripts-disabled install succeeded. The moved set was @babel/types 8.0.4, @babel/helper-string-parser 8.0.0, and @babel/helper-validator-identifier 8.0.4; all are MIT, script-free, mature, and clean in GHSA/OSV for both incoming and outgoing versions. Published source review found no suspicious shipped runtime behavior or compromise reports.

The upgrade is not independently absorbable. CI has 23 completed check runs with failures in lint and both viable-release jobs from incompatible Babel 7/8 AST types. A scripts-disabled coordinated experiment bumping parser/traverse/generator to Babel 8 still produced API/export and TypeScript failures, changed source-map snapshots, runtime transform failures, and 114 ses-test failures, requiring a separately reviewed family migration. The project dependabotany ledger was updated in entries/2026/08/05/154426Z-message-botanist-d33305.md.

Self-improvement: nothing this time.
