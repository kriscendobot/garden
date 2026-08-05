---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-05T15:44:28Z
---
# Dependabotany — endojs/endo-but-for-bots PR 918

project: endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/918
package: @babel/types
upgrade: 7.29.0 -> 8.0.4
verdict: REJECT
maturity_floor: 2026-07-16T08:49:44.644Z
freshest_moved_version: @babel/types@8.0.4 published 2026-07-09T08:49:44.644Z
state: CLOSED
verdict_comment: https://github.com/endojs/endo-but-for-bots/pull/918#issuecomment-5193963736
reason: The isolated types major leaves Babel 7 parser/traverse/generator at the same call sites, producing real CI type failures. A coordinated Babel 8 experiment exposed API/export changes, source-map snapshot changes, and 114 runtime test failures, so absorption requires a separately reviewed family migration.
advisories: No GHSA or OSV advisories on either side of the three-package moved set; yarn audit found no advisory on those moved packages.
